import 'package:flutter/material.dart';
import 'package:knowledgematch/model/userprofile.dart';
import 'swipe_screen.dart';
import '../model/search_criteria.dart';
import '../services/matching_algorithm.dart';
import '../model/reachability.dart';

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
    print("got Keywords");
    reachabilities = (await MatchingAlgorithm().getReachabilities())!;
    print("got reachabilites");
    setState(() {});
  }

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
    }); // Sort matching profiles by seniority  (0-seniority is prioritized the least)
    return profiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('KnowledgeMatch'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
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
                items: keywords.map((topic) {
                  return DropdownMenuItem<String>(
                    value: topic,
                    child: Text(topic),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    keyword = value;
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
                  description = value;
                },
              ),
              const SizedBox(height: 24),

              // Connection dropdown
              const Text("How do you want to connect?"),
              DropdownButtonFormField<Reachability>(
                decoration: const InputDecoration(
                  hintText: 'Select an option',
                ),
                items: reachabilities.map((reachability) {
                  return DropdownMenuItem<Reachability>(
                    value: reachability,
                    child: Text(reachability.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    reachability = value;
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
                child: const Text('Search helpers'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
