import 'package:flutter/material.dart';
import 'package:knowledgematch/domain/models/reachability.dart';
import 'package:knowledgematch/domain/models/search_criteria.dart';
import 'package:knowledgematch/ui/find_matches/view_model/find_matches_view_model.dart';
import 'package:knowledgematch/ui/swipe/view_model/swipe_view_model.dart';
import 'package:knowledgematch/widgets/app_drawer.dart';

import '../../swipe/widgets/swipe_screen.dart';

class FindMatchesScreen extends StatefulWidget {
  final FindMatchesViewModel viewModel;

  const FindMatchesScreen({
    super.key,
    required this.viewModel,
  });

  @override
  FindMatchesScreenState createState() => FindMatchesScreenState();
}

class FindMatchesScreenState extends State<FindMatchesScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadData();
  }

  @override
  Widget build(BuildContext context) {
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
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select a topic',
                ),
                items: widget.viewModel.keywords.map((topic) {
                  return DropdownMenuItem<String>(
                    value: topic,
                    child: Text(topic),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    widget.viewModel.keyword = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a topic';
                  }
                  return null;
                },
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
                  widget.viewModel.description = value;
                },
              ),
              const SizedBox(height: 24),

              // Connection dropdown
              const Text("How do you want to connect?"),
              DropdownButtonFormField<Reachability>(
                decoration: const InputDecoration(
                  hintText: 'Select an option',
                ),
                items: widget.viewModel.reachabilities.map((reachability) {
                  return DropdownMenuItem<Reachability>(
                    value: reachability,
                    child: Text(reachability.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    widget.viewModel.reachability = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a connection type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    SearchCriteria searchCriteria = SearchCriteria(
                      keyword: widget.viewModel.keyword!,
                      issue: widget.viewModel.description!,
                      reachability: widget.viewModel.reachability,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SwipeScreen(
                            viewModel: SwipeViewModel(
                          searchCriteria: searchCriteria,
                        )),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Search helpers'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
