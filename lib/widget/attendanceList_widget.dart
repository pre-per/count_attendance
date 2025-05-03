import 'package:count_attendance/provider/sumList_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendancelistWidget extends ConsumerWidget {
  const AttendancelistWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sumListinRange = ref.watch(sumListProvider);
    final listEntries = sumListinRange.entries.toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: listEntries.length,
      itemBuilder:
          (context, index) => SumListInkWell(
            name: listEntries[index].key,
            peopleNum: listEntries[index].value,
          ),
    );
  }
}

class SumListInkWell extends StatelessWidget {
  final String name;
  final int peopleNum;

  const SumListInkWell({
    super.key,
    required this.name,
    required this.peopleNum,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Ink(
        color: Colors.white,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  name,
                  softWrap: true,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
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
    );
  }
}
