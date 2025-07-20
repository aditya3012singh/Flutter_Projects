import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/colors.dart';
import 'package:todo_app/data/notenxuslogo.dart';
import 'package:todo_app/views/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      appBar: AppBar(
        title: NoteNexusLogo(),
        backgroundColor: const Color.fromARGB(255, 247, 250, 250),

        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage(
                'assets/images/image.png',
              ), // Replace with your image
            ),
            const SizedBox(height: 16),
            Text(
              "Aditya",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "adityanotenexus@gmail.com",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.grey.shade300),

            ListTile(
              leading: const Icon(LucideIcons.userCog),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to edit profile screen
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.bookOpen),
              title: const Text('My Notes'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to My Notes screen
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.lightbulb),
              title: const Text('My Tips'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to My Tips screen
              },
            ),
            ListTile(
              leading: const Icon(LucideIcons.logOut),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
