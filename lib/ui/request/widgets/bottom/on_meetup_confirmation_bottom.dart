import 'package:flutter/material.dart';

class OnMeetupConfirmationBottom extends StatelessWidget {
  const OnMeetupConfirmationBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: (() => Navigator.pop(context)),
          child: Text('Exit'),
        ),
      ],
    );
  }
}
