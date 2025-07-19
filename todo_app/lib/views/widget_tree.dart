import 'package:flutter/material.dart';
import 'package:todo_app/data/notenxuslogo.dart';
import 'package:todo_app/data/notifiers.dart';
import 'package:todo_app/views/pages/home_page.dart';
import 'package:todo_app/views/pages/profile_page.dart';
import 'package:todo_app/views/pages/settings_page.dart';

/// List of pages to display based on the selected index.
final List<Widget> pages = [const HomePage(), const ProfilePage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NoteNexusLogo(),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, _) {
          return pages[selectedPage];
        },
      ),
      // bottomNavigationBar: const NavbarWidget(), // Uncomment if needed
    );
  }
}
