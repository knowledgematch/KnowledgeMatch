import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/keyword_selection/view_model/keyword_selection_view_model.dart';
import 'package:provider/provider.dart';

import 'keyword_selection.dart';

/// Screen for selecting keywords.
///
/// Displays all available keywords along with checkboxes and shows which keywords the user has selected.
/// Changes are saved only when the user taps the save button.
class KeywordSelectionScreen extends StatefulWidget {
  const KeywordSelectionScreen({super.key});

  @override
  KeywordSelectionScreenState createState() => KeywordSelectionScreenState();
}

/// State for [KeywordSelectionScreen].
class KeywordSelectionScreenState extends State<KeywordSelectionScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => KeywordSelectionViewModel(),
        child: KeywordSelection()
    );

  }


}
