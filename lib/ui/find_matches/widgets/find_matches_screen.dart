import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/find_matches/view_model/find_matches_view_model.dart';
import 'package:knowledgematch/ui/find_matches/widgets/find_matches_form.dart';
import 'package:provider/provider.dart';


class FindMatchesScreen extends StatefulWidget {

  const FindMatchesScreen({
    super.key,
  });

  @override
  FindMatchesScreenState createState() => FindMatchesScreenState();
}

class FindMatchesScreenState extends State<FindMatchesScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => FindMatchesViewModel(),
      child: FindMatchesForm()
    );

  }
}
