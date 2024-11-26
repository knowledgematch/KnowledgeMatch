import 'package:flutter/material.dart';
import '../model/userprofile.dart';
import 'create_profile_screen.dart'; // Import the CreateProfileScreen file
import 'package:knowledgematch/services/db_connection.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  // Beispiel-Liste von Experten
  final List<Userprofile> experts = [
    Userprofile(
      name: 'Dr. Max Mustermann',
      location: 'Zurich',
      expertString: 'AI Robotics',
      availability: 'Mon-Fri, 9:00 - 17:00',
      langString: 'English German',
      description: 'Expert in Artificial Intelligence and Robotics',
      seniority: 10,
    ),
    Userprofile(
      name: 'Prof. Jane Doe',
      location: 'Basel',
      expertString: 'Physics Chemistry',
      availability: 'Tue-Thu, 10:00 - 15:00',
      langString: 'English French',
      description: 'Specialist in Quantum Physics',
      seniority: 8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experts'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: experts.length, // Anzahl der Experten in der Liste
        itemBuilder: (context, index) {
          final expert = experts[index];
          return ExpertCard(profile: expert); // Nutze das ExpertCard-Widget
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
          );
        },
        tooltip: 'Add Account',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Neues Widget für die Expertenkarte
class ExpertCard extends StatelessWidget {
  final Userprofile profile;

  ExpertCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Schatteneffekt
      margin: const EdgeInsets.all(16), // Außenabstand
      child: Padding(
        padding: const EdgeInsets.all(16), // Innenabstand
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Elemente links ausrichten
          children: [
            // Profilbild hinzufügen (Platzhalter, falls keins verfügbar ist)
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/profile.png'), // Statisches Bild
              child: Text(
                profile.name[0], // Initialen des Experten anzeigen
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // Name des Experten
            Text(
              profile.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            // Beschreibung / Qualifikationen des Experten
            Text(
              profile.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            // Verfügbarkeiten
            Text(
              'Availability: ${profile.availability}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            // Sprachen
            Text(
              'Languages: ${profile.languages.join(", ")}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}