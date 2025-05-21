import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowledgematch/ui/core/themes/app_colors.dart';
import 'package:knowledgematch/ui/find_matches/view_model/find_matches_view_model.dart';
import 'package:knowledgematch/ui/find_matches/widgets/keyword_selector.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/search_criteria.dart';
import '../../core/ui/app_drawer.dart';
import '../../swipe/view_model/swipe_view_model.dart';
import '../../swipe/widgets/swipe_screen.dart';

class FindMatchesScreen extends StatefulWidget {
  const FindMatchesScreen({super.key});

  @override
  FindMatchesScreenState createState() => FindMatchesScreenState();
}

class FindMatchesScreenState extends State<FindMatchesScreen> {
  final _formKey = GlobalKey<FormState>();


  final TextEditingController _descriptionController = TextEditingController();
  static const int _maxChars = 1000;


  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

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
              const Text("What is the topic you are having problems with?"),
              KeywordSelector(),
              const SizedBox(height: 24),

              const Text("Please describe your issue:"),


              StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 7,
                        maxLength: _maxChars,
                        decoration: const InputDecoration(
                          hintText:
                          'For example: How does one proceed in a curve discussion?',
                          border: OutlineInputBorder(),
                          counterText: '',
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your issue';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.length > _maxChars) {
                            _descriptionController.text =
                                value.substring(0, _maxChars);
                            _descriptionController.selection =
                                TextSelection.fromPosition(
                                  TextPosition(
                                      offset: _descriptionController.text.length),
                                );
                          }
                          setState(() {});
                        },
                        onSaved: (value) {
                          viewModel.updateDescription(value);
                        },
                      ),

                      const SizedBox(height: 4),
                      Text(
                        '${_maxChars - _descriptionController.text.length} characters remaining',
                        style: TextStyle(
                          fontSize: 12,
                          color: _descriptionController.text.length >= _maxChars
                              ? AppColors.redLight
                              : AppColors.grey6Light,
                        ),
                      ),
                    ],
                  );
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
                      keyword: viewModel.state.keyword!.name,
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

                child: const Text('Search experts'),
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
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("How do you want to connect?"),
      Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var choice in FindMatchesViewModel.choices)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    showCheckmark: false,
                    label: Text(choice["text"]!),
                    selected: viewModel.state.reachability == choice["value"],
                    onSelected: (bool selected) {
                      viewModel.updateReachability(choice["value"]);
                    },
                  ),
                )
            ],
          ),
        ),
      ),
      if (viewModel.state.reachability == null)
        Text(
          "Please select a location option",
          style: TextStyle(
            color: AppColors.redLight,
            fontSize: 13,
          ),
        ),
    ],
  );
}
