import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/domain/models/request_date_data.dart';
import 'package:provider/provider.dart';

import '../view_model/request_view_model.dart';

class MultiDateTimePicker extends StatefulWidget {
  const MultiDateTimePicker({super.key});

  @override
  MultiDateTimePickerState createState() => MultiDateTimePickerState();
}

class MultiDateTimePickerState extends State<MultiDateTimePicker> {
  /// Opens a date and time picker to allow the user to select a specific date and time.
  ///
  /// The function first shows a date picker, then a time picker if a valid date is selected.
  /// It combines the selected date and time into a `DateTime` object and adds it to the `selectedTimeFrames` list.
  /// Once a valid date-time is selected, it calls the `onDatesSelected` callback with the updated list.
  void _addDateTime() async {
    final viewModel = context.read<RequestViewModel>();
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
        viewModel.addSelectedDate(RequestDateData(dateTime: combinedDateTime));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    List<Reachability> eligibleReachability = <Reachability>[];
    switch (viewModel.state.searchCriteria.reachability) {
      case Reachability.online:
        eligibleReachability.add(Reachability.online);
      case Reachability.inPerson:
        eligibleReachability.add(Reachability.inPerson);
      case Reachability.onlineOrInPerson:
        eligibleReachability.addAll(Reachability.values);
      case null:
        eligibleReachability.addAll(Reachability.values);
    }
    return Column(
      children: [
        ElevatedButton(
          onPressed: _addDateTime,
          child: Text('Add Date & Time' ,style: TextStyle(color: AppColors.white),),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: viewModel.state.selectedDates.length,
            itemBuilder: (context, index) {
              final date =
                  viewModel.state.selectedDates[index].getFormattedDate();
              final time =
                  viewModel.state.selectedDates[index].getFormattedTime();
              return Card(
                child: ListTile(
                  title: Row(
                    children: [
                      Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(date)),  // Wrap date text with Expanded
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text("Time: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(time)),  // Wrap time text with Expanded
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: DropdownButton<Reachability>(
                        value:
                            viewModel.state.selectedDates[index].reachability ??
                                viewModel.state.searchCriteria.reachability,
                        items: eligibleReachability.map((Reachability value) {
                          return DropdownMenuItem<Reachability>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                        onChanged: (Reachability? newValue) {
                          viewModel.changeReachabilityOnSelectedDate(
                              index, newValue);
                        },
                      ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => viewModel.removeSelectedDate(index),
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
