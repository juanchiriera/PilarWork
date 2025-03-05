import 'package:flutter/material.dart';
import 'package:pilarwork_app/model/espacio_model.dart';
import 'package:pilarwork_app/deprecated/time_picker_page.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({super.key, required Espacio espacio});

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  DateTime? _selectedDay;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fecha para tu reserva'),
      ),
      body: Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.95,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarHeader(),
                const Divider(),
                Expanded(
                  child: TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 90)),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) =>
                        _isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) => setState(() {
                      _calendarFormat = format;
                    }),
                    // !_isRangeSelected && _isSameDay(_selectedDay, day),
                    // rangeStartDay: _isRangeSelected ? _rangeStart : null,
                    // rangeEndDay: _isRangeSelected ? _rangeEnd : null,
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      rangeHighlightColor: Colors.blue[100]!,
                      rangeStartDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      rangeEndDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      withinRangeDecoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      // TODO: Open a day view calendar to see reservations for the selected date.
                      // Fetch reservations using GET: /api/reservas?fechaInicio=selectedDay&fechaFin=selectedDay for a range
                      // or GET: /api/reservas?fechaSeleccionada=selectedDay for a single date.
                      setState(() {
                        // if (_isRangeSelected) {
                        //   if (_rangeStart == null ||
                        //       (_rangeStart != null && _rangeEnd != null)) {
                        //     _rangeStart = selectedDay;
                        //     _rangeEnd = null;
                        //   } else {
                        //     _rangeEnd = selectedDay;
                        //   }
                        // } else {
                        _selectedDay = selectedDay;
                        // }
                        _focusedDay = focusedDay;
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return TimePickerModal(selectedDay: selectedDay);
                            });
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() => _focusedDay = focusedDay);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // _buildSelectedDatesPreview(),
                const SizedBox(height: 16),
                // _buildDialogActions(context, espacioId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Que dia te gustaria reservar?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Spacer(),
      ],
    );
  }
}
