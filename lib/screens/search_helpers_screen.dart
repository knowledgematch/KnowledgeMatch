import 'package:flutter/material.dart';
import 'swipe_screen.dart';
import '../model/search_criteria.dart';

class FindMatchesScreen extends StatefulWidget {
  const FindMatchesScreen({super.key});

  @override
  FindMatchesScreenState createState() => FindMatchesScreenState();
}

class FindMatchesScreenState extends State<FindMatchesScreen> {
  final _formKey = GlobalKey<FormState>();
  String? topic;
  DateTime? selectedTimeFrame;
  String? description;
  String? country;

  final List<String> topics = ['OOP', 'Data Structures', 'Algorithms', 'Networking', 'Databases'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Match'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const Text("What is the topic you are having problems with?"),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Select a topic',
                ),
                items: topics.map((topic) {
                  return DropdownMenuItem<String>(
                    value: topic,
                    child: Text(topic),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    topic = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a topic';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              const Text("What is your desired time frame to discuss the matter?"),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedTimeFrame = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: selectedTimeFrame != null
                        ? '${selectedTimeFrame!.toLocal()}'.split(' ')[0]
                        : 'Date and Time Selector',
                  ),
                  child: Text(
                    selectedTimeFrame != null
                        ? '${selectedTimeFrame!.toLocal()}'.split(' ')[0]
                        : 'Select Date',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description field
              const Text("Please describe your issue:"),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'For example: How does one proceed in a curve discussion?',
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

              const Text("Find students and experts near you"),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'for e.g., Brugg (optional)',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  country = value;
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    SearchCriteria searchCriteria = SearchCriteria(
                      topic: topic!,
                      timeFrame: selectedTimeFrame != null
                          ? selectedTimeFrame!.toIso8601String()
                          : '',
                      description: description!,
                      location: country,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SwipeScreen(searchCriteria: searchCriteria),
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
