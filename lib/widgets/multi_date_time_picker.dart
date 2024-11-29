import 'package:flutter/material.dart';

class MultiDateTimePicker extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onDatesSelected;

  const MultiDateTimePicker({
    super.key,
    required this.onDatesSelected,
  });

  @override
  MultiDateTimePickerState createState() => MultiDateTimePickerState();
}

class MultiDateTimePickerState extends State<MultiDateTimePicker> {
  List<Map<String, dynamic>> selectedTimeFrames = [];

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
        setState(() {
          selectedTimeFrames.add({
            'date': '${pickedDate.toLocal()}'.split(' ')[0],
            'time': '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}',
          });
        });
        widget.onDatesSelected(selectedTimeFrames);
      }
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
      mainAxisSize: MainAxisSize.min, // Shrink-wrap the children
      children: [
        SizedBox(
          height: 280,
          child: ListView.builder(
            itemCount: selectedTimeFrames.length,
            itemBuilder: (context, index) {
              final date = selectedTimeFrames[index]['date'];
              final time = selectedTimeFrames[index]['time'];
              return Card(
                child: ListTile(
                  title: Text(date),
                  subtitle: Text(time),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeDateTime(index),
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: _addDateTime,
          child: Text('Add Date & Time'),
        ),
        // if (selectedTimeFrames.isNotEmpty)
        //   ElevatedButton(
        //     onPressed: _submitDates,
        //     child: Text('Submit Dates'),
        //   ),
      ],
    );
  }
}
