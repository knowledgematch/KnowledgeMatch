import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/request_date_data.dart';
import 'package:knowledgematch/ui/core/ui/decorations.dart';
import 'package:knowledgematch/ui/request/view_model/request_view_model.dart';
import 'package:provider/provider.dart';

class OnMeetupRequestBody extends StatefulWidget {
  const OnMeetupRequestBody({super.key});

  @override
  OnMeetupRequestBodyState createState() => OnMeetupRequestBodyState();
}

class OnMeetupRequestBodyState extends State<OnMeetupRequestBody> {
  @override
  void initState() {
    super.initState();
    final viewModel = context.read<RequestViewModel>();
    viewModel.parseIncomingDates();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: Decorations.container,
              child: ListTile(
                title: Text(
                  'Meetup Request:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Icon(
                  Icons.date_range,
                  color: Colors.orange,
                  size: 40,
                ),
              ),
            ),
            SizedBox(height: 8),
            if (viewModel.state.incomingDates.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 11.0),
                child: Text(
                  'Select a proposed date and time:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            SizedBox(height: 8),
            if (viewModel.state.incomingDates.isNotEmpty)
              ...viewModel.state.incomingDates.map((
                RequestDateData requestedDate,
              ) {
                String date = requestedDate.getFormattedDate();
                String time = requestedDate.getFormattedTime();
                return RadioListTile<RequestDateData>(
                  radioScaleFactor: 0.6,
                  title: Row(
                    children: [
                      Text(
                        'Date: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(child: Text(date)),
                    ],
                  ),
                  // ),
                  subtitle: Row(
                    children: [
                      Text(
                        'Time: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(time),
                    ],
                  ),
                  value: requestedDate,
                  groupValue: viewModel.state.selectedDate,
                  onChanged: (value) {
                    viewModel.setSelectedDate(value);
                  },
                  secondary: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          textAlign: TextAlign.end,
                          requestedDate.reachability.toString(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            if (viewModel.state.incomingDates.isEmpty)
              Text(
                'No dates proposed. Please suggest new dates.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
          ],
        );
      },
    );
  }
}
