import 'dart:core';

class DateRange {
  final String startDate;
  final String endDate;

  DateRange({String? startDate, String? endDate})
    : startDate =
          startDate ?? DateTime.now().subtract(Duration(days: 365)).toString(),
      endDate = endDate ?? DateTime.now().toString();

  DateRange copyWith({String? startDate, String? endDate}) {
    return DateRange(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  bool get isValid => DateTime.parse(startDate).isBefore(DateTime.parse(endDate));
}
