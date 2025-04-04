import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/find_matches/view_model/find_matches_view_model.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/reachability.dart';
import '../../../domain/models/search_criteria.dart';
import '../../core/themes/app_colors.dart';
import '../../core/ui/app_drawer.dart';
import '../../core/ui/custom_drop_down.dart';
import '../../swipe/view_model/swipe_view_model.dart';
import '../../swipe/widgets/swipe_screen.dart';

class FindMatchesScreen extends StatefulWidget {
  const FindMatchesScreen({
    super.key,
  });

  @override
  FindMatchesScreenState createState() => FindMatchesScreenState();
}

class FindMatchesScreenState extends State<FindMatchesScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FindMatchesViewModel>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('KnowledgeMatch'),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Topics dropdown
              const Text("What is the topic you are having problems with?"),
              CustomDropdown<String>(
                items: viewModel.state.keywords,
                selectedItem: viewModel.state.keyword,
                hintText: 'Select a topic',
                onChanged: (value) {
                  viewModel.updateKeyword(value);
                },
                validator: (value) =>
                    value == null ? 'Please select a topic' : null,
              ),
              const SizedBox(height: 24),

              // Issue field
              const Text("Please describe your issue:"),
              TextFormField(
                maxLines: 7,
                decoration: const InputDecoration(
                  hintText:
                      'For example: How does one proceed in a curve discussion?',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe your issue';
                  }
                  return null;
                },
                onSaved: (value) {
                  viewModel.updateDescription(value);
                },
              ),
              const SizedBox(height: 24),

              _locationSelection(context),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    SearchCriteria searchCriteria = SearchCriteria(
                      keyword: viewModel.state.keyword!,
                      issue: viewModel.state.description!,
                      reachability: viewModel.state.reachability,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) =>
                              SwipeViewModel(searchCriteria: searchCriteria),
                          child: SwipeScreen(),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Search helpers',
                    style: TextStyle(color: AppColors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Column _locationSelection(BuildContext context) {
  final viewModel = context.watch<FindMatchesViewModel>();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text("How do you want to connect?"),
      // const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: [
          // In Person Chip
          ChoiceChip(
            label: const Text("In Person"),
            selected: viewModel.state.reachability == Reachability.inPerson,
            onSelected: (bool selected) {
              viewModel.updateReachability(Reachability.inPerson);
            },
          ),
          // Online Chip
          ChoiceChip(
            label: const Text("Online"),
            selected: viewModel.state.reachability == Reachability.online,
            onSelected: (bool selected) {
              viewModel.updateReachability(Reachability.online);
            },
          ),
          // In Person / Online Chip
          ChoiceChip(
            label: const Text("In Person / Online"),
            selected:
                viewModel.state.reachability == Reachability.onlineOrInPerson,
            onSelected: (bool selected) {
              viewModel.updateReachability(Reachability.onlineOrInPerson);
            },
          ),
        ],
      ),
      // Display error text if validation fails.
      if (viewModel.state.reachability == null)
        Text(
          "Please select a location option",
          style: const TextStyle(
            color: Colors.red,
            fontSize: 13,
          ),
        ),
    ],
  );
}
