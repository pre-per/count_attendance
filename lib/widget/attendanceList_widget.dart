import 'package:count_attendance/model/dateRange_model.dart';
import 'package:count_attendance/provider/classList_provider.dart';
import 'package:count_attendance/provider/classListinDateRange_provider.dart';
import 'package:count_attendance/provider/date_state_provider.dart';
import 'package:count_attendance/provider/sumList_provider.dart';
import 'package:count_attendance/screen/class_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AttendancelistWidget extends ConsumerStatefulWidget {
  const AttendancelistWidget({super.key});

  @override
  ConsumerState<AttendancelistWidget> createState() => _AttendancelistWidgetState();
}

class _AttendancelistWidgetState extends ConsumerState<AttendancelistWidget> {
  List<bool> isCheckedList = [];
  bool isAllChecked = false;

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(classListProvider);
    final listInRange = ref.watch(classListInDateRangeProvider);
    final sumListinRange = ref.watch(sumListProvider);
    final listEntries = sumListinRange.entries.toList();
    final dateprovider = ref.watch(dateProvider);
    final dateNotifier = ref.watch(dateProvider.notifier);

    return listAsync.when(
      data: (classList) {
        if (listEntries.isEmpty) return const SizedBox.shrink();

        // ✅ 체크리스트 초기화
        if (isCheckedList.length != listEntries.length) {
          isCheckedList = List.generate(listEntries.length, (_) => false);
        }

        // ✅ 체크된 총합 계산
        final checkedSum = listEntries.asMap().entries.fold<int>(0, (prev, entry) {
          final i = entry.key;
          return prev + (isCheckedList[i] ? entry.value.value : 0);
        });

        final checkedLengthSum = listEntries.asMap().entries.fold<int>(0, (prev, entry) {
          final i = entry.key;
          final classList = listInRange.where((c) => c.name == entry.value.key).toList();
          return prev + (isCheckedList[i] ? classList.length : 0);
        });

        return Column(
          children: [
            // 날짜 설정 영역
            InkWell(
              onTap: () {
                dateNotifier.setRange(
                  DateRange(
                    startDate: classList.first.date,
                    endDate: classList.last.date,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('선택 가능한 전체 범위의 날짜로 변경되었습니다!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Ink(
                child: Text(
                  '선택 가능한 날짜:  ${DateFormat('yyyy-MM-dd').format(classList.first.date)} ~ ${DateFormat('yyyy-MM-dd').format(classList.last.date)}',
                  style: TextStyle(fontSize: 17.0, color: Colors.green[700]),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ✅ 전체 선택 버튼 추가
            TextButton.icon(
              onPressed: () {
                setState(() {
                  isAllChecked = !isAllChecked;
                  isCheckedList = List.generate(listEntries.length, (_) => isAllChecked);
                });
              },
              icon: Icon(isAllChecked ? Icons.check_box : Icons.check_box_outline_blank),
              label: Text(isAllChecked ? '전체 해제' : '전체 선택'),
            ),

            const SizedBox(height: 10),

            // 리스트
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey, width: 0.3),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox()
                        ),
                        Expanded(
                          flex: 6,
                          child: Text('강좌명', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text('총 인원', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text('강좌수', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text('평균인원', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listEntries.length,
                    itemBuilder: (context, index) {
                      final name = listEntries[index].key;
                      final sum = listEntries[index].value;
                      final classList = listInRange.where((c) => c.name == name).toList();

                      return SumListInkWell(
                        name: name,
                        peopleNum: sum,
                        length: classList.length,
                        isChecked: isCheckedList[index],
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedList[index] = value!;
                            isAllChecked = isCheckedList.every((v) => v);
                          });
                        },
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ClassDetailScreen(
                                title: name,
                                sum: sum,
                                classList: classList,
                                dateRange: dateprovider,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Text(
              '✔ 선택된 항목 총합: $checkedSum명   ✔ 총 강좌 수: $checkedLengthSum건',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        );
      },
      error: (error, stack) => Center(child: Text('오류발생: $error')),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class SumListInkWell extends StatelessWidget {
  final String name;
  final int peopleNum;
  final int length;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final Function() onTap;

  const SumListInkWell({
    super.key,
    required this.name,
    required this.peopleNum,
    required this.length,
    required this.isChecked,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Checkbox(
                    value: isChecked,
                    onChanged: onChanged,
                    activeColor: Colors.deepPurple,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text('$peopleNum명', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text('$length건', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text('${(peopleNum/length).toStringAsFixed(2)}명', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
