import 'package:count_attendance/provider/date_state_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatepickWidget extends ConsumerWidget {
  const DatepickWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(dateProvider);
    final dateNotifier = ref.watch(dateProvider.notifier);
    final startDate = selectedDate.startDate;
    final endDate = selectedDate.endDate;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SelectDateRow(
          date: startDate,
          onPressed: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate.startDate,
              firstDate: DateTime(2000, 1, 1),
              lastDate: DateTime(2100, 1, 1),
            );

            if (pickedDate != null && context.mounted) {
              if (dateNotifier.changeStartDate(pickedDate)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '시작일이 ${DateFormat('yyyy-MM-dd').format(pickedDate)}로 변경되었습니다!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('시작일은 종료일 이전이어야 합니다.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
        Text('-', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SelectDateRow(
          date: endDate,
          onPressed: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate.endDate,
              firstDate: DateTime(2000, 1, 1),
              lastDate: DateTime(2100, 1, 1),
            );

            if (pickedDate != null && context.mounted) {
              if (dateNotifier.changeEndDate(pickedDate)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '종료일이 ${DateFormat('yyyy-MM-dd').format(pickedDate)}로 변경되었습니다!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('종료일은 시작일 이후여야 합니다.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}

class SelectDateRow extends StatelessWidget {
  final DateTime date;
  final Function() onPressed;

  const SelectDateRow({super.key, required this.date, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          DateFormat('yyyy-MM-dd').format(date),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        IconButton(onPressed: onPressed, icon: Icon(Icons.calendar_month)),
      ],
    );
  }
}
