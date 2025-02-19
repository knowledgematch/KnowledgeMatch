import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/domain/models/request_date_data.dart';

class MultiDateTimePicker extends StatefulWidget {
  final Function(List<RequestDateData>) onDatesSelected;
  final Reachability searchCriteriaReachability;

  const MultiDateTimePicker(
      {super.key,
      required this.onDatesSelected,
      required this.searchCriteriaReachability});

  @override
  MultiDateTimePickerState createState() => MultiDateTimePickerState();
}

class MultiDateTimePickerState extends State<MultiDateTimePicker> {
  List<RequestDateData> selectedTimeFrames = [];

  /// Opens a date and time picker to allow the user to select a specific date and time.
  ///
  /// The function first shows a date picker, then a time picker if a valid date is selected.
  /// It combines the selected date and time into a `DateTime` object and adds it to the `selectedTimeFrames` list.
  /// Once a valid date-time is selected, it calls the `onDatesSelected` callback with the updated list.
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

  /// Removes a selected date-time at the specified [index] from the [selectedTimeFrames] list.
  void _removeDateTime(int index) {
    setState(() {
      selectedTimeFrames.removeAt(index);
    });
    widget.onDatesSelected(selectedTimeFrames);
  }

  @override
  Widget build(BuildContext context) {
    List<Reachability> elligibleReachability = <Reachability>[];
    switch (widget.searchCriteriaReachability) {
      case Reachability.online:
        elligibleReachability.add(Reachability.online);
      case Reachability.inPerson:
        elligibleReachability.add(Reachability.inPerson);
      case Reachability.onlineOrInPerson:
        elligibleReachability.addAll(Reachability.values);
    }
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
                      DropdownButton<Reachability>(
                        value: selectedTimeFrames[index].reachability ??
                            widget.searchCriteriaReachability,
                        items: elligibleReachability.map((Reachability value) {
                          return DropdownMenuItem<Reachability>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (Reachability? newValue) {
                          setState(() {
                            selectedTimeFrames[index].reachability = newValue;
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
