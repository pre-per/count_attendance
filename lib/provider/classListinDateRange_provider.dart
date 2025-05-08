import 'package:count_attendance/model/class_model.dart';
import 'package:count_attendance/provider/classList_provider.dart';
import 'package:count_attendance/provider/date_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final classListInDateRangeProvider = Provider<List<Class>>((ref) {
  final classListAsync = ref.watch(classListProvider);
  final dateRangeProvider = ref.watch(dateProvider);

  return classListAsync.maybeWhen(
    data: (classList) {
      return classList
          .where(
            (c) =>
                c.date.isAfter(
                  dateRangeProvider.startDate.subtract(Duration(days: 1)),
                ) &&
                c.date.isBefore(
                  dateRangeProvider.endDate.add(Duration(days: 1)),
                ),
          )
          .toList();
    },
    orElse: () => [],
  );
});
