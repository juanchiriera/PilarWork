import 'package:flutter/material.dart';

class CalendarDialog extends StatelessWidget {
  final Function(DateTime) onDateSelected;

  const CalendarDialog({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select a date'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: CalendarDatePicker(
          initialDate: DateTime.now(),
          firstDate: DateTime(2024),
          lastDate: DateTime(2040),
          onDateChanged: (date) {
            onDateSelected(date);
            // Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
