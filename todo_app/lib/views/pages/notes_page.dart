import 'package:flutter/material.dart';
import 'package:todo_app/data/colors.dart';
import 'package:todo_app/data/notenxuslogo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:todo_app/views/models/note_model.dart';
import 'package:todo_app/views/services/api.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      await ApiService.loadTokenFromPrefs(); // load token if needed

      if (ApiService.token == null) {
        setState(() {
          error = 'Not authenticated.';
          isLoading = false;
        });
        return;
      }

      final rawData = await ApiService.getAllNotes();
      final fetchedNotes = rawData
          .map<Note>((json) => Note.fromJson(json))
          .toList();

      setState(() {
        notes = fetchedNotes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  void _openFile(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open file")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        247,
        250,
        250,
      ), // Light pastel background
      appBar: AppBar(
        title: const NoteNexusLogo(),
        backgroundColor: const Color.fromARGB(255, 247, 250, 250),

        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : notes.isEmpty
          ? const Center(child: Text('No notes available'))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              itemCount: notes.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      '📒 Study Notes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: LunaColors.deepTeal,
                      ),
                    ),
                  );
                }

                final note = notes[index - 1];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 250, 250),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Branch: ${note.branch}'),
                          Text('Semester: ${note.semester}'),
                          Text('Uploaded: ${note.createdAt.split('T')[0]}'),
                          if (note.subject != null)
                            Text('Subject: ${note.subject!['name']}'),
                          if (note.uploadedBy != null)
                            Text('Uploader: ${note.uploadedBy!['name']}'),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.download_rounded,
                        color: LunaColors.aquaBlue,
                      ),
                      onPressed: () => _openFile(note.fileUrl),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
