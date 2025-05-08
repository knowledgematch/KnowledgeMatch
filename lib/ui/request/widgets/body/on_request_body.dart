import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/ui/decorations.dart';
import 'package:provider/provider.dart';

import '../../view_model/request_view_model.dart';

class OnRequestBody extends StatelessWidget {
  const OnRequestBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RequestViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: Decorations.container,
          child: ListTile(
            title: Text(
              "New Knowledge request",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.question_mark_rounded,
              color: Colors.orange,
              size: 40,
            ),
          ),
        ),

        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            'Problem description:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: Decorations.container,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              viewModel.state.searchCriteria.issue,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(height: 16),
        // Action Buttons
      ],
    );
  }
}
