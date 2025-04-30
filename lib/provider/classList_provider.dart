import 'package:count_attendance/model/class_model.dart';
import 'package:count_attendance/widget/dragzone_widget.dart';
import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final classListProvider = FutureProvider<List<Class>>((ref) async {
  final file = ref.watch(fileProvider);

  if (file == null) return [];

  // -----------------------
  // 엑셀 파일 불러오기
  // -----------------------

  final bytes = await file.readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  final sheet = excel.tables[excel.tables.keys.first];

  if (sheet == null) return [];

  final rows = sheet.rows;

  if (rows.isEmpty) return [];

  // ------------------------
  // 헤더에서 이름, 날짜, 사람 수 열 찾기
  // ------------------------

  final header = rows.first;
  int nameIdx = -1;
  int dateIdx = -1;
  int peopleIdx = -1;

  for (int i = 0; i < header.length; i++) {
    final headerName = header[i]?.value?.toString() ?? '';

    if (headerName == '강좌명') {
      nameIdx = i;
    } else if (headerName == '출결일자') {
      dateIdx = i;
    } else if (headerName == '출석인원') {
      peopleIdx = i;
    }
  }

  if (nameIdx == -1 || dateIdx == -1 || peopleIdx == -1) {
    throw Exception('필수 열(이름/날짜/인원 수)을 찾을 수 없습니다.');
  }

  // --------------------
  // User 모델화하기
  // --------------------

  List<Class> classes = [];

  for (int i = 1; i < rows.length; i++) {
    final row = rows[i];

    classes.add(
      Class(
        name: row[nameIdx]?.value?.toString() ?? 'Unknown',
        date: row[dateIdx]?.value?.toString() ?? 'Unknown',
        peopleNum: row[peopleIdx] as int? ?? -1,
      ),
    );
  }

  return classes;
});
