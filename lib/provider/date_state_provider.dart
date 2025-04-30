import 'package:count_attendance/model/dateRange_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateStateProvider = StateProvider<DateRange>((ref) {
  return DateRange();
});
