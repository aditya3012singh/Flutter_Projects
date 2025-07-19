import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:todo_app/data/notenxuslogo.dart';

class DashboardPage extends StatelessWidget {
  final String userName;

  const DashboardPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
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
        'color': Colors.amber,
      },
      {
        'name': 'Upcoming Events',
        'value': '2',
        'icon': LucideIcons.calendar,
        'color': Colors.green,
      },
      {
        'name': 'Announcements',
        'value': '4',
        'icon': LucideIcons.messageSquare,
        'color': Colors.purple,
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

    return Scaffold(
      appBar: AppBar(title: const NoteNexusLogo(), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Welcome Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
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
                            'Welcome back, $userName! 👋',
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
                    const Icon(
                      LucideIcons.award,
                      color: Colors.white,
                      size: 48,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Stats Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: stats.map((stat) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: stat['color']! as Color,
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
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Quick Actions
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
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
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

              // Progress Section
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
                        Text(
                          '75%',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.75,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
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
        ),
      ),
    );
  }
}
