import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:todo_app/data/colors.dart';
import 'package:todo_app/data/notenxuslogo.dart';
import 'package:todo_app/views/pages/announcements_page.dart';
import 'package:todo_app/views/pages/events_page.dart';
import 'package:todo_app/views/pages/notes_page.dart';
import 'package:todo_app/views/pages/tips_page.dart';

class DashboardPage extends StatefulWidget {
  final String userName;
  const DashboardPage({super.key, required this.userName});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildDashboardContent(),
      const NotesPage(),
      const TipsPage(),
      const UserEventsPage(),
      const AnnouncementPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildDashboardContent() {
    final stats = [
      {
        'name': 'My Notes',
        'value': '5',
        'icon': LucideIcons.bookOpen,
        'color': Colors.blue,
      },
      {
        'name': 'Study Tips',
        'value': '3',
        'icon': LucideIcons.lightbulb,
        'color': Colors.blue,
      },
      {
        'name': 'Upcoming Events',
        'value': '2',
        'icon': LucideIcons.calendar,
        'color': Colors.blue,
      },
      {
        'name': 'Announcements',
        'value': '4',
        'icon': LucideIcons.messageSquare,
        'color': Colors.blue,
      },
    ];

    final quickActions = [
      {
        'name': 'Browse Notes',
        'desc': 'Explore study materials',
        'icon': LucideIcons.bookOpen,
      },
      {
        'name': 'Share Tip',
        'desc': 'Help fellow students',
        'icon': LucideIcons.lightbulb,
      },
      {
        'name': 'View Events',
        'desc': 'Upcoming activities',
        'icon': LucideIcons.calendar,
      },
      {
        'name': 'Announcements',
        'desc': 'Latest updates',
        'icon': LucideIcons.messageSquare,
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [LunaColors.deepTeal, LunaColors.aquaBlue],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${widget.userName}! 👋',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Continue your learning journey and explore new knowledge with NoteNexus.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.award, color: Colors.white, size: 48),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: stats.map((stat) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 222, 243, 245),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      stat['icon'] as IconData,
                      color: stat['color'] as Color,
                      size: 28,
                    ),
                    const Spacer(),
                    Text(
                      stat['name'] as String,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      stat['value'] as String,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(LucideIcons.zap, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  children: quickActions.map((action) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: CircleAvatar(
                        backgroundColor: const Color.fromARGB(
                          255,
                          216,
                          243,
                          243,
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: Colors.black87,
                        ),
                      ),
                      title: Text(action['name'] as String),
                      subtitle: Text(action['desc'] as String),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(LucideIcons.barChart3, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      'Learning Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Keep up the great work! You\'re making excellent progress.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Overall Progress'),
                    Text('75%', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.75,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation(Colors.blueAccent),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      LucideIcons.star,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Dedicated Learner',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<BottomNavigationBarItem> get _bottomItems => const [
    BottomNavigationBarItem(
      icon: Icon(LucideIcons.layoutDashboard),
      label: 'Home',
    ),
    BottomNavigationBarItem(icon: Icon(LucideIcons.bookOpen), label: 'Notes'),
    BottomNavigationBarItem(icon: Icon(LucideIcons.lightbulb), label: 'Tips'),
    BottomNavigationBarItem(icon: Icon(LucideIcons.calendar), label: 'Events'),
    BottomNavigationBarItem(
      icon: Icon(LucideIcons.messageSquare),
      label: 'News',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const NoteNexusLogo(),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 247, 250, 250),
            )
          : null, // Only show AppBar on Home page

      body: _pages[_selectedIndex],
      backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: LunaColors.aquaBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      ),
    );
  }
}
