import 'package:flutter/material.dart';
import 'package:knowledgematch/models/reachability.dart';
import 'package:knowledgematch/models/search_criteria.dart';
import 'package:knowledgematch/models/userprofile.dart';
import 'package:knowledgematch/services/matching_algorithm.dart';
import 'package:knowledgematch/widgets/app_drawer.dart';

import '../../../domain/models/reachability.dart';
import '../../../domain/models/search_criteria.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/custom_drop_down.dart';
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

              // Connection CHOICE CHIPS
              const Text("How do you want to connect?"),
              CustomDropdown<Reachability>(
                items: viewModel.state.reachabilities,
                selectedItem: viewModel.state.reachability,
                onChanged: (value) {
                  viewModel.updateReachability(value);
              FormField<Reachability>(
                validator: (value) {
                  if (reachability == null) {
                    return 'Please select a connection type';
                  }
                  return null;
                },
                builder: (fieldState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        children: [
                          // --- In Person ---
                          ChoiceChip(
                            label: const Text("In Person"),
                            selected: reachability == Reachability.inPerson,
                            onSelected: (bool selected) {
                              setState(() {
                                reachability =
                                selected ? Reachability.inPerson : null;
                              });
                              fieldState.validate();
                            },
                          ),

                          // --- Online ---
                          ChoiceChip(
                            label: const Text("Online"),
                            selected: reachability == Reachability.online,
                            onSelected: (bool selected) {
                              setState(() {
                                reachability =
                                selected ? Reachability.online : null;
                              });
                              fieldState.validate();
                            },
                          ),

                          // --- Online/In Person ---
                          ChoiceChip(
                            label: const Text("In Person / Online"),
                            selected: reachability ==
                                Reachability.onlineOrInPerson,
                            onSelected: (bool selected) {
                              setState(() {
                                reachability =
                                selected ? Reachability.onlineOrInPerson : null;
                              });
                              fieldState.validate();
                            },
                          ),
                        ],
                      ),

                      // Validierungs-Fehlermeldung (falls vorhanden)
                      if (fieldState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            fieldState.errorText!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  );
                },
                validator: (value) =>
                    value == null ? 'Please select a connection type' : null,
              ),
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
                child: Text(
                  'Search helpers',
                  style: TextStyle(
                    color: AppColors.whiteLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}