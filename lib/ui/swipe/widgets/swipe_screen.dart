import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/userprofile.dart';
import 'package:knowledgematch/ui/swipe/view_model/swipe_view_model.dart';
import 'package:knowledgematch/ui/swipe/widgets/card_stack.dart';
import 'package:provider/provider.dart';

class SwipeScreen extends StatefulWidget {
  final SwipeViewModel viewModel;

  const SwipeScreen({
    super.key,
    required this.viewModel,
  });

  @override
  ProfileSwipeScreenState createState() => ProfileSwipeScreenState();
}

class ProfileSwipeScreenState extends State<SwipeScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child:FutureBuilder<List<Userprofile>>(
        future: widget.viewModel.profilesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text("Error")),
              body: Center(child: Text("Error: ${snapshot.error}")),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: const Text("No Matches")),
              body: const Center(
                child: Text(
                  "No more profiles to show!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          widget.viewModel.setProfiles(snapshot.data!);

          return CardStack();
        },
      )
    );
  }

}
