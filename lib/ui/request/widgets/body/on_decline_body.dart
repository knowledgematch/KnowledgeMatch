import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/request_view_model.dart';

class OnDeclineBody extends StatelessWidget {
  const OnDeclineBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              viewModel.notificationData.body,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.cancel, color: Colors.red, size: 40),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
