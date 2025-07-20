import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/colors.dart';
import 'package:todo_app/data/notenxuslogo.dart';
import 'package:todo_app/views/pages/welcome_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');

    Fluttertoast.showToast(msg: "Logged out successfully");

    // Replace '/login' with your actual home/login route name
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
    );
  }

  void _comingSoon() {
    Fluttertoast.showToast(msg: "Coming soon!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: NoteNexusLogo(),
        backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      ),
      backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // Profile section
          const ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
              backgroundColor: LunaColors.aquaBlue,
              foregroundColor: Colors.white,
            ),
            title: Text('Aditya'),
            subtitle: Text('Student • CSE'),
          ),
          const Divider(),

          // Settings options
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Update Profile'),
            onTap: _comingSoon,
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy & Security'),
            onTap: _comingSoon,
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            onTap: _comingSoon,
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification Settings'),
            onTap: _comingSoon,
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: _comingSoon,
          ),
          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
