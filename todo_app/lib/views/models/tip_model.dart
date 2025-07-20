import 'user_model.dart';
import 'feedback_model.dart';

class Tip {
  final String id;
  final String title;
  final String content;
  final String status;
  final String createdAt;
  final String? postedById;
  final String? approvedById;
  final User? postedBy;
  final User? approvedBy;
  final List<FeedbackModel>? feedbacks;

  Tip({
    required this.id,
    required this.title,
    required this.content,
    required this.status,
    required this.createdAt,
    this.postedById,
    this.approvedById,
    this.postedBy,
    this.approvedBy,
    this.feedbacks,
  });

  factory Tip.fromJson(Map<String, dynamic> json) => Tip(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    content: json['content'] ?? '',
    status: json['status'] ?? '',
    createdAt: json['createdAt'] ?? '',
    postedById: json['postedById'],
    approvedById: json['approvedById'],
    postedBy: json['postedBy'] != null ? User.fromJson(json['postedBy']) : null,
    approvedBy: json['approvedBy'] != null
        ? User.fromJson(json['approvedBy'])
        : null,
    feedbacks: json['feedbacks'] != null
        ? List<FeedbackModel>.from(
            json['feedbacks'].map((x) => FeedbackModel.fromJson(x)),
          )
        : [],
  );
}
