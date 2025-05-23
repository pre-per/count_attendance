import 'dart:core';

class DateRange {
  DateTime startDate;
  DateTime endDate;

  DateRange({DateTime? startDate, DateTime? endDate})
    : startDate = startDate ?? DateTime.now().subtract(Duration(days: 1000)),
      endDate = endDate ?? DateTime.now();

  DateRange copyWith({DateTime? startDate, DateTime? endDate}) {
    return DateRange(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  bool get isValid => startDate.isBefore(endDate);
}
