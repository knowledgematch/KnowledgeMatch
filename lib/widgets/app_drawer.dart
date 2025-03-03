import 'package:flutter/material.dart';
import 'package:knowledgematch/screens/about_screen.dart';
import 'package:knowledgematch/screens/contact_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFbcb9b0),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
                child: Row(
              children: [
                ClipOval(
                  child: Image.asset('assets/images/logo.png', width: 50),
                ),
                // Image.asset('assets/images/logo.png', width: 50),
                const SizedBox(width: 10),
                const Text(
                  'KnowledgeMatch',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            )),
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.black,
            ),
            title: const Text(
              'About',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.contact_mail,
              color: Colors.black,
            ),
            title: const Text(
              'Contact',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
