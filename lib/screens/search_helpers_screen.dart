import 'package:flutter/material.dart';
import 'package:knowledgematch/models/reachability.dart';
import 'package:knowledgematch/models/search_criteria.dart';
import 'package:knowledgematch/models/userprofile.dart';
import 'package:knowledgematch/services/matching_algorithm.dart';
import 'package:knowledgematch/widgets/app_drawer.dart';

import '../widgets/custom_drop_down.dart';
import 'swipe_screen.dart';

class FindMatchesScreen extends StatefulWidget {
  const FindMatchesScreen({super.key});

  @override
  FindMatchesScreenState createState() => FindMatchesScreenState();
}

class FindMatchesScreenState extends State<FindMatchesScreen> {
  final _formKey = GlobalKey<FormState>();
  String? keyword;
  String? description;
  Reachability? reachability;

  late List<String> keywords = [];
  late List<Reachability> reachabilities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    keywords = await MatchingAlgorithm().getKeywords();
    reachabilities = (await MatchingAlgorithm().getReachabilities())!;
    setState(() {});
  }

  //TODO move to service method:
  /// Retrieves a list of user profiles that match the specified search criteria.
  ///
  /// This method uses a [MatchingAlgorithm] to identify profiles that meet
  /// the given [searchCriteria]. The resulting list of profiles is sorted
  /// by seniority in ascending order, with profiles having a seniority of 0
  /// prioritized the least.
  ///
  /// Parameters:
  /// - [searchCriteria]: The criteria used to filter and match user profiles.
  ///
  /// Returns a [Future] containing a sorted list of [Userprofile] objects.
  ///
  /// Sorting Behavior:
  /// - Profiles with `seniority == 0` are put to -1 as it indicates a lecturer.
  /// - Other profiles are sorted in ascending order of their seniority values.
  Future<List<Userprofile>> _getMatchingUserProfiles(
      SearchCriteria searchCriteria) async {
    Future<List<Userprofile>> matchingProfiles =
        MatchingAlgorithm().matchingAlgorithm(searchCriteria);
    List<Userprofile> profiles = await matchingProfiles;
    profiles.sort((a, b) {
      if (a.seniority == 0) {
        return 1;
      } else if (b.seniority == 0) {
        return -1;
      } else {
        return a.seniority.compareTo(b.seniority);
      }
    });
    return profiles;
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
              CustomDropdown<String>(
                items: keywords,
                selectedItem: keyword,
                hintText: 'Select a topic',
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
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
                  description = value;
                },
              ),
              const SizedBox(height: 24),

              // Connection dropdown
              const Text("How do you want to connect?"),
              CustomDropdown<Reachability>(
                items: reachabilities,
                selectedItem: reachability,
                onChanged: (value) {
                  setState(() {
                    reachability = value;
                  });
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
                      keyword: keyword!,
                      issue: description!,
                      reachability: reachability,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SwipeScreen(
                            searchCriteria: searchCriteria,
                            profiles: _getMatchingUserProfiles(searchCriteria)),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Search helpers',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
