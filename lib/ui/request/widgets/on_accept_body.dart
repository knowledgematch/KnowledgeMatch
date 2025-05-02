import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/request_view_model.dart';
import 'multi_date_time_picker.dart';

class OnAcceptBody extends StatefulWidget {
  const OnAcceptBody({super.key});

  @override
  OnAcceptBodyState createState() => OnAcceptBodyState();
}

class OnAcceptBodyState extends State<OnAcceptBody> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
              title: Text(
                viewModel.notificationData.body,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing:
                  Icon(Icons.check_circle, color: Colors.green, size: 40)),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(
            'Create a meetup request:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 6),
        ChangeNotifierProvider.value(
            value: viewModel, child: const MultiDateTimePicker()),
        Spacer(),
        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: viewModel.notificationData.isOpen == true
                  ? () async {
                      if (viewModel.state.selectedDates.isEmpty) {
                        // Show error if no dates are selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Please select at least one date!")),
                        );
                        return;
                      }
                      // Show success message and close
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Meetup request sent!")),
                        );
                        Navigator.pop(context);
                      }
                      viewModel.proposeSelectedDates();
                    }
                  : null,
              child: Text('Send'),
            ),
          ],
        ),
        Spacer()
      ],
    );
  }
}
