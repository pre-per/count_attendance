import 'package:count_attendance/model/dateRange_model.dart';
import 'package:count_attendance/provider/classList_provider.dart';
import 'package:count_attendance/provider/classListinDateRange_provider.dart';
import 'package:count_attendance/provider/date_state_provider.dart';
import 'package:count_attendance/provider/sumList_provider.dart';
import 'package:count_attendance/screen/class_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AttendancelistWidget extends ConsumerWidget {
  const AttendancelistWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(classListProvider);
    final listInRange = ref.watch(classListInDateRangeProvider);
    final sumListinRange = ref.watch(sumListProvider);
    final listEntries = sumListinRange.entries.toList();
    final dateprovider = ref.watch(dateProvider);
    final dateNotifier = ref.watch(dateProvider.notifier);

    return listAsync.when(
      data: (classList) {
        if (listEntries.isEmpty) return const SizedBox.shrink();
        return Column(
          children: [
            InkWell(
              onTap: () {
                dateNotifier.setRange(
                  DateRange(
                    startDate: classList.first.date,
                    endDate: classList.last.date,
                  ),
                );
              },
              child: Ink(
                child: Text(
                  '선택 가능한 날짜:  ${DateFormat('yyyy-MM-dd').format(
                      classList.first.date)} ~ ${DateFormat('yyyy-MM-dd')
                      .format(classList.last.date)}',
                  style: TextStyle(fontSize: 17.0, color: Colors.green[700]),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey, width: 0.3),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: listEntries.length,
                itemBuilder:
                    (context, index) {
                  final name = listEntries[index].key;
                  final sum = listEntries[index].value;

                  return SumListInkWell(
                    name: name,
                    peopleNum: sum,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (
                          _) =>
                          ClassDetailScreen(title: name, sum: sum,
                              classList: listInRange.where((c) => c.name == name).toList(), dateRange: dateprovider,)));
                    },
                  );
                },
              ),
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
  final Function() onTap;

  const SumListInkWell({
    super.key,
    required this.name,
    required this.peopleNum, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        color: Colors.white,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  name,
                  softWrap: true,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    peopleNum.toString(),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
