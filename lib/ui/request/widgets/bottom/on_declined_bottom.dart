import 'package:flutter/material.dart';

class OnDeclinedBottom extends StatelessWidget {
  const OnDeclinedBottom({super.key});

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
