import 'package:count_attendance/model/class_model.dart';
import 'package:count_attendance/model/dateRange_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassDetailScreen extends StatelessWidget {
  final String title;
  final int sum;
  final List<Class> classList;
  final DateRange dateRange;

  const ClassDetailScreen({
    super.key,
    required this.title,
    required this.classList,
    required this.dateRange,
    required this.sum,
  });

  @override
  Widget build(BuildContext context) {
    if (classList.isEmpty)
      return Center(
        child: Text(
          '비어 있는 리스트입니다.',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$title [${DateFormat('yyyy-MM-dd').format(dateRange.startDate)} ~ ${DateFormat('yyyy-MM-dd').format(dateRange.endDate)}]',
        ),
        actions: [
          Text(
            '총 개수: ${classList.length}건',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 20),
          Text(
            '합계: $sum명',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: classList.length,
            itemBuilder: (context, index) {
              return ClassListDetailsWidget(
                title: title,
                date: classList[index].date,
                peopleNum: classList[index].peopleNum,
              );
            },
          ),
        ),
      ),
    );
  }
}

class ClassListDetailsWidget extends StatelessWidget {
  final String title;
  final DateTime date;
  final int peopleNum;

  const ClassListDetailsWidget({
    super.key,
    required this.title,
    required this.date,
    required this.peopleNum,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0),
        child: Ink(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(title, style: TextStyle(fontSize: 18.0)),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  DateFormat('yyyy-MM-dd').format(date),
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '${peopleNum.toString()}명',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
