import 'package:flutter/material.dart';
import 'package:todo_app/data/notenxuslogo.dart';
import 'package:todo_app/views/models/user_model.dart';
import '../models/announcement_model.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  List<Announcement> announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDummyAnnouncements();
  }

  void loadDummyAnnouncements() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    setState(() {
      announcements = [
        Announcement(
          id: '1',
          title: '🎉 Welcome to NoteNexus',
          message: 'We are excited to launch our new academic platform.',
          createdAt: '2025-07-19T10:30:00Z',
          postedById: 'user1',
          postedBy: User(
            id: 'user1',
            name: 'Admin',
            email: 'admin@example.com',
            role: "ADMIN",
            createdAt: "1",
          ),
        ),
        Announcement(
          id: '2',
          title: '🗓️ Mid-Term Exam Schedule Released',
          message: 'Please check the exam schedule in your dashboard.',
          createdAt: '2025-07-18T14:20:00Z',
          postedById: 'user2',
          postedBy: User(
            id: 'user2',
            name: 'Professor Ahuja',
            email: 'ahuja@example.com',
            role: "ADMIN",
            createdAt: "1",
          ),
        ),
        Announcement(
          id: '3',
          title: '⚙️ Maintenance Downtime',
          message:
              'Platform will be down for maintenance on July 22 from 1 AM to 3 AM.',
          createdAt: '2025-07-17T08:00:00Z',
          postedById: 'user3',
          postedBy: User(
            id: 'user3',
            name: 'Support Team',
            email: 'support@example.com',
            role: "ADMIN",
            createdAt: "1",
          ),
        ),
      ];
      isLoading = false;
    });
  }

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      appBar: AppBar(
        title: const NoteNexusLogo(),
        backgroundColor: const Color.fromARGB(255, 247, 250, 250),
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : announcements.isEmpty
          ? const Center(child: Text('No announcements available.'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
                  child: Text(
                    '📢 Announcements',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final ann = announcements[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: const Color.fromARGB(255, 247, 250, 250),
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ann.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                ann.message,
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    ann.postedBy?.name ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    formatDate(ann.createdAt),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
