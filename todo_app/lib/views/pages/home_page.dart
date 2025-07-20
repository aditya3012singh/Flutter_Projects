import 'package:flutter/material.dart';
import 'package:todo_app/data/colors.dart';
import 'package:todo_app/views/pages/announcements_page.dart';
import 'package:todo_app/views/pages/dashboard_page.dart';
import 'package:todo_app/views/pages/events_page.dart';
import 'package:todo_app/views/pages/files_page.dart';
import 'package:todo_app/views/pages/notes_page.dart';
import 'package:todo_app/views/pages/tips_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'NoteNexus', home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    HomeCard(
                      title: "Dashboard",
                      icon: Icons.dashboard,
                      color: LunaColors.aquaBlue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DashboardPage(userName: "Aditya"),
                          ),
                        );
                      },
                    ),
                    HomeCard(
                      title: "Study Notes",
                      icon: Icons.book,
                      color: LunaColors.aquaBlue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotesPage()),
                        );
                      },
                    ),
                    HomeCard(
                      title: "Study Tips",
                      icon: Icons.lightbulb,
                      color: LunaColors.aquaBlue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TipsPage()),
                        );
                      },
                    ),
                    HomeCard(
                      title: "Events",
                      icon: Icons.event,
                      color: LunaColors.aquaBlue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserEventsPage(),
                          ),
                        );
                      },
                    ),
                    HomeCard(
                      title: "Announcements",
                      icon: Icons.campaign,
                      color: LunaColors.aquaBlue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnnouncementPage(),
                          ),
                        );
                      },
                    ),
                    HomeCard(
                      title: "Files",
                      icon: Icons.folder,
                      color: LunaColors.aquaBlue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserFilesPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const HomeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 247, 250, 250),
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
