import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:todo_app/data/colors.dart';
import 'package:todo_app/data/notenxuslogo.dart';

class UserEventsPage extends StatefulWidget {
  const UserEventsPage({Key? key}) : super(key: key);

  @override
  State<UserEventsPage> createState() => _UserEventsPageState();
}

class _UserEventsPageState extends State<UserEventsPage> {
  List<dynamic> events = [];
  String searchTerm = '';
  String filter = 'all';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://autonomous-kiet-hub.onrender.com/api/v1/events/event',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          events = data['events'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<dynamic> get filteredEvents {
    final now = DateTime.now();
    return events.where((event) {
      final title = event['title'].toString().toLowerCase();
      final content = event['content'].toString().toLowerCase();
      final matchSearch =
          title.contains(searchTerm.toLowerCase()) ||
          content.contains(searchTerm.toLowerCase());

      if (!matchSearch) return false;

      final eventDate = DateTime.parse(event['eventDate']);
      if (filter == 'upcoming') {
        return eventDate.isAfter(now);
      } else if (filter == 'past') {
        return eventDate.isBefore(now);
      }
      return true;
    }).toList();
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  Widget statusTag(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    if (date.isAfter(now)) {
      return _tag("Upcoming", LunaColors.deepTeal);
    } else if (date.isBefore(now)) {
      return _tag("Past", Colors.grey);
    } else {
      return _tag("Today", LunaColors.lightSky);
    }
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NoteNexusLogo(),
        backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      ),
      backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📅 Academic Events',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: LunaColors.deepTeal,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Search and Filter UI
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search events...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) =>
                              setState(() => searchTerm = value),
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: filter,
                        onChanged: (value) => setState(() => filter = value!),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All')),
                          DropdownMenuItem(
                            value: 'upcoming',
                            child: Text('Upcoming'),
                          ),
                          DropdownMenuItem(value: 'past', child: Text('Past')),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // List of events
                  Expanded(
                    child: filteredEvents.isEmpty
                        ? const Center(child: Text('No events found.'))
                        : ListView.builder(
                            itemCount: filteredEvents.length,
                            itemBuilder: (context, index) {
                              final event = filteredEvents[index];
                              return Card(
                                elevation: 3,
                                color: const Color.fromARGB(255, 247, 250, 250),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  title: Text(
                                    event['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(event['content']),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(formatDate(event['eventDate'])),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: statusTag(event['eventDate']),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
