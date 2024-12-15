import 'package:flutter/material.dart';

import '../model/request_date_data.dart';

class MultiDateTimePicker extends StatefulWidget {
  final Function(List<RequestDateData>) onDatesSelected;

  const MultiDateTimePicker({
    super.key,
    required this.onDatesSelected,
  });

  @override
  MultiDateTimePickerState createState() => MultiDateTimePickerState();
}

class MultiDateTimePickerState extends State<MultiDateTimePicker> {
  List<RequestDateData> selectedTimeFrames = [];

  void _addDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null && mounted) {
        final DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          selectedTimeFrames.add(
            RequestDateData(dateTime: combinedDateTime),
          );
        });
      }
      widget.onDatesSelected(selectedTimeFrames);
    }
  }

  void _removeDateTime(int index) {
    setState(() {
      selectedTimeFrames.removeAt(index);
    });
    widget.onDatesSelected(selectedTimeFrames);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _addDateTime,
          child: Text('Add Date & Time'),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: selectedTimeFrames.length,
            itemBuilder: (context, index) {
              final date = selectedTimeFrames[index].getFormattedDate();
              final time = selectedTimeFrames[index].getFormattedTime();
              return Card(
                child: ListTile(
                  title: Row(children: [
                    Text("Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(date)
                  ]),
                  subtitle: Row(children: [
                    Text("Time: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(time)
                  ]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<MeetingType>(
                        value: selectedTimeFrames[index].meetingType ??
                            MeetingType.onlineOrInPerson,
                        items: MeetingType.values.map((MeetingType type) {
                          return DropdownMenuItem<MeetingType>(
                            value: type,
                            child: Text(type.toString()),
                          );
                        }).toList(),
                        onChanged: (MeetingType? newValue) {
                          setState(() {
                            selectedTimeFrames[index].meetingType = newValue;
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeDateTime(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
