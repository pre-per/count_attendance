import 'package:count_attendance/provider/classListinDateRange_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sumListProvider = Provider<Map<String, int>>((ref) {
  final classListInRange = ref.watch(classListInDateRangeProvider);

  final sumList = <String, int>{};
  for (var c in classListInRange) {
    sumList[c.name] = (sumList[c.name] ?? 0) + c.peopleNum;
  }

  return sumList;
});