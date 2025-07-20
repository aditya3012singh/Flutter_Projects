import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:todo_app/data/notenxuslogo.dart'; // Make sure this file contains NoteNexusLogo widget

class UserFilesPage extends StatefulWidget {
  const UserFilesPage({super.key});

  @override
  State<UserFilesPage> createState() => _UserFilesPageState();
}

class _UserFilesPageState extends State<UserFilesPage> {
  List<Map<String, dynamic>> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), loadDummyNotes);
  }

  void loadDummyNotes() {
    setState(() {
      notes = [
        {
          'title': 'Operating Systems - Unit 1 Notes',
          'subject': 'Operating Systems',
          'branch': 'CSE',
          'semester': 4,
          'createdAt': '2025-07-15T09:30:00Z',
          'fileUrl': 'https://example.com/os-unit1.pdf',
        },
        {
          'title': 'Discrete Mathematics Notes',
          'subject': 'Discrete Math',
          'branch': 'IT',
          'semester': 3,
          'createdAt': '2025-07-16T11:00:00Z',
          'fileUrl': 'https://example.com/dm-notes.pdf',
        },
        {
          'title': 'Digital Logic Design',
          'subject': 'Digital Logic',
          'branch': 'ECE',
          'semester': 2,
          'createdAt': '2025-07-14T14:15:00Z',
          'fileUrl': 'https://example.com/dld.pdf',
        },
      ];
      isLoading = false;
    });
  }

  Future<void> downloadNote(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: "Could not launch file URL");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NoteNexusLogo(), // App logo here
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
          ? const Center(child: Text("No notes uploaded yet."))
          : ListView.builder(
              itemCount: notes.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemBuilder: (context, index) {
                final note = notes[index];
                final title = note['title'] ?? 'Untitled';
                final subject = note['subject'] ?? 'Unknown';
                final semester = note['semester']?.toString() ?? '-';
                final branch = note['branch'] ?? 'Unknown';
                final date = note['createdAt']?.substring(0, 10) ?? 'N/A';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Subject: $subject • Sem: $semester • Branch: $branch\nUploaded on: $date",
                      style: const TextStyle(height: 1.4),
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        final fileUrl = note['fileUrl'];
                        if (fileUrl != null) {
                          downloadNote(fileUrl);
                        } else {
                          Fluttertoast.showToast(msg: 'File URL not found');
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
