import 'package:flutter/material.dart';
import 'package:todo_app/data/notenxuslogo.dart';
import 'package:todo_app/views/models/tip_model.dart';
import 'package:todo_app/views/models/user_model.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  List<Tip> _tips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDummyTips();
  }

  Future<void> _loadDummyTips() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate loading delay
    setState(() {
      _tips = [
        Tip(
          id: '1',
          title: 'Time Management',
          content: 'Use a planner to organize your day effectively.',
          status: 'APPROVED',
          createdAt: '2025-07-20T10:00:00Z',
          postedById: 'u1',
          approvedById: 'a1',
          postedBy: User(
            id: 'u1',
            name: 'Aditya',
            email: 'aditya@example.com',
            role: 'USER',
            createdAt: '2025-07-10T09:00:00Z',
          ),
          approvedBy: User(
            id: 'a1',
            name: 'Admin',
            email: 'admin@example.com',
            role: 'ADMIN',
            createdAt: '2025-07-01T12:00:00Z',
          ),
          feedbacks: [],
        ),
        Tip(
          id: '2',
          title: 'Study Breaks',
          content: 'Take 5–10 minute breaks after 45 minutes of study.',
          status: 'PENDING',
          createdAt: '2025-07-18T09:30:00Z',
          postedById: 'u2',
          approvedById: null,
          postedBy: User(
            id: 'u2',
            name: 'Riya',
            email: 'riya@example.com',
            role: 'USER',
            createdAt: '2025-07-12T15:00:00Z',
          ),
          approvedBy: null,
          feedbacks: [],
        ),
        Tip(
          id: '3',
          title: 'Group Study',
          content: 'Discuss topics with peers to strengthen understanding.',
          status: 'APPROVED',
          createdAt: '2025-07-15T08:15:00Z',
          postedById: null,
          approvedById: 'a2',
          postedBy: null,
          approvedBy: User(
            id: 'a2',
            name: 'Moderator',
            email: 'mod@example.com',
            role: 'MODERATOR',
            createdAt: '2025-06-25T10:30:00Z',
          ),
          feedbacks: [],
        ),
      ];
      _isLoading = false;
    });
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green.shade100;
      case 'PENDING':
        return Colors.orange.shade100;
      case 'REJECTED':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _statusTextColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return Colors.green.shade800;
      case 'PENDING':
        return Colors.orange.shade800;
      case 'REJECTED':
        return Colors.red.shade800;
      default:
        return Colors.black87;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      appBar: AppBar(
        title: const NoteNexusLogo(),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 247, 250, 250),

        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    '📘 Study Tips',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _tips.length,
                    itemBuilder: (context, index) {
                      final tip = _tips[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tip.content,
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(tip.status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Status: ${tip.status}',
                                style: TextStyle(
                                  color: _statusTextColor(tip.status),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Posted by: ${tip.postedBy?.name ?? 'N/A'} (${tip.postedBy?.role ?? 'N/A'})',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Approved by: ${tip.approvedBy?.name ?? 'Not approved'} (${tip.approvedBy?.role ?? 'N/A'})',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
