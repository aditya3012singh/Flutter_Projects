import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/classes/activity_class.dart';
import 'package:flutter_application_1/views/widgets/hero_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late Future<Activity> activityFuture;

  @override
  void initState() {
    super.initState();
    activityFuture = getData();
  }

  Future<Activity> getData() async {
    final url = Uri.https('bored-api.appbrewery.com', '/random');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load activity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Course Page")),
      body: FutureBuilder<Activity>(
        future: activityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found.'));
          }

          final activity = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeroWidget(title: activity.activity),
                  const SizedBox(height: 16),
                  InfoRow(label: "Type", value: activity.type),
                  InfoRow(
                    label: "Participants",
                    value: activity.participants.toString(),
                  ),
                  InfoRow(label: "Price", value: activity.price.toString()),
                  InfoRow(
                    label: "Availability",
                    value: activity.availability.toString(),
                  ),
                  InfoRow(
                    label: "Accessibility",
                    value: activity.accessibility,
                  ),
                  InfoRow(label: "Duration", value: activity.duration),
                  InfoRow(
                    label: "Kid Friendly",
                    value: activity.kidFriendly ? "Yes" : "No",
                  ),
                  InfoRow(label: "Link", value: activity.link),
                  InfoRow(label: "Key", value: activity.key),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
