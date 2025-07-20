import 'user_model.dart';

class Announcement {
  final String id;
  final String title;
  final String message;
  final String createdAt;
  final String postedById;
  final User? postedBy;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.postedById,
    this.postedBy,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    id: json['id'],
    title: json['title'],
    message: json['message'],
    createdAt: json['createdAt'],
    postedById: json['postedById'],
    postedBy: json['postedBy'] != null ? User.fromJson(json['postedBy']) : null,
  );
}
