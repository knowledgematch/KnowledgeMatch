import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/ui/decorations.dart';
import 'package:provider/provider.dart';

import '../../view_model/request_view_model.dart';
import '../widget/multi_date_time_picker.dart';

class OnAcceptBody extends StatefulWidget {
  const OnAcceptBody({super.key});

  @override
  OnAcceptBodyState createState() => OnAcceptBodyState();
}

class OnAcceptBodyState extends State<OnAcceptBody> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: Decorations.container,
            child: ListTile(
              title: Text(
                viewModel.notificationData.body,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Icon(Icons.check_circle, color: Colors.green, size: 40),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Create a meetup request:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ChangeNotifierProvider.value(
            value: viewModel,
            child: const MultiDateTimePicker(),
          ),
        ],
      ),
    );
  }
}
