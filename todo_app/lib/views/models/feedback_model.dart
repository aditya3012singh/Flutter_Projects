import 'user_model.dart';

class FeedbackModel {
  final String id;
  final String content;
  final String createdAt;
  final String userId;
  final String? noteId;
  final String? tipId;
  final User? user;

  FeedbackModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.userId,
    this.noteId,
    this.tipId,
    this.user,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
    id: json['id'],
    content: json['content'],
    createdAt: json['createdAt'],
    userId: json['userId'],
    noteId: json['noteId'],
    tipId: json['tipId'],
    user: json['user'] != null ? User.fromJson(json['user']) : null,
  );
}
