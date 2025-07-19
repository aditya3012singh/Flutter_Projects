import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:todo_app/data/notenxuslogo.dart';
import 'package:todo_app/views/services/api.dart'; // Update this path
import 'dart:io';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, dynamic>> notes = [];
  String selectedBranch = 'All';
  String selectedSemester = 'All';
  String searchQuery = '';

  final List<String> branches = ['All', 'CSE', 'IT', 'ECE', 'ME'];
  final List<String> semesters = [
    'All',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
  ];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() async {
    try {
      final apiService = ApiService();
      final result = await apiService.getAllNotes();

      if (result != null && result['notes'] is List) {
        setState(() {
          notes = List<Map<String, dynamic>>.from(result['notes']);
        });
      } else {
        Fluttertoast.showToast(msg: 'Unexpected response from server');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to fetch notes: $e');
    }
  }

  List<Map<String, dynamic>> get filteredNotes {
    return notes.where((note) {
      final subject = note['subject'] ?? {};
      final title = note['title']?.toString().toLowerCase() ?? '';

      final matchesBranch =
          selectedBranch == 'All' || subject['branch'] == selectedBranch;
      final matchesSemester =
          selectedSemester == 'All' ||
          subject['semester'].toString() == selectedSemester;
      final matchesSearch = title.contains(searchQuery.toLowerCase());

      return matchesBranch && matchesSemester && matchesSearch;
    }).toList();
  }

  void pickFileAndUpload() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      Fluttertoast.showToast(msg: 'Picked file: ${file.path}');
      // TODO: Upload file API integration
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NoteNexusLogo(),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: pickFileAndUpload,
          ),
        ],
      ),
      body: Column(
        children: [
          Text("Notes"),
          // Filter section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedBranch,
                  items: branches.map((branch) {
                    return DropdownMenuItem(value: branch, child: Text(branch));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBranch = value!;
                    });
                  },
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: selectedSemester,
                  items: semesters.map((semester) {
                    return DropdownMenuItem(
                      value: semester,
                      child: Text('Sem $semester'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSemester = value!;
                    });
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by title',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Notes list
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(child: Text('No notes found.'))
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      final subject = note['subject'] ?? {};
                      final uploader = note['uploadedBy'] ?? {};
                      final title = note['title'] ?? 'Untitled';
                      final subjectName = subject['name'] ?? 'Unknown Subject';
                      final branch = subject['branch'] ?? 'Unknown';
                      final semester = subject['semester'] ?? '';
                      final uploaderName = uploader['name'] ?? 'Unknown';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(title),
                          subtitle: Text(
                            '$subjectName • $branch • Sem $semester\nBy: $uploaderName',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              final url = note['fileUrl'];
                              if (url != null) {
                                // TODO: implement download logic with url
                                Fluttertoast.showToast(
                                  msg: 'Downloading not implemented yet',
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'File URL not found',
                                );
                              }
                            },
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
