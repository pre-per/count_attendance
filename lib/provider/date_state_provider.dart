import 'package:count_attendance/model/dateRange_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateProvider = StateNotifierProvider<DateNotifier, DateRange>(
  (ref) => DateNotifier(),
);

class DateNotifier extends StateNotifier<DateRange> {
  DateNotifier() : super(DateRange());

  bool changeStartDate(DateTime pickedDate) {
    final updated = state.copyWith(startDate: pickedDate);
    if (!updated.isValid) return false;

    state = updated;
    return true;
  }

  bool changeEndDate(DateTime pickedDate) {
    final updated = state.copyWith(endDate: pickedDate);
    if (!updated.isValid) return false;

    state = updated;
    return true;
  }

  void setRange(DateRange range) {
    state = DateRange(startDate: range.startDate, endDate: range.endDate);
  }
}
