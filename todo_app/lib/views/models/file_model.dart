import 'user_model.dart';

class AppFile {
  final String id;
  final String url;
  final String filename;
  final String type;
  final int size;
  final String uploadedById;
  final String createdAt;
  final User? uploadedBy;

  AppFile({
    required this.id,
    required this.url,
    required this.filename,
    required this.type,
    required this.size,
    required this.uploadedById,
    required this.createdAt,
    this.uploadedBy,
  });

  factory AppFile.fromJson(Map<String, dynamic> json) => AppFile(
    id: json['id'],
    url: json['url'],
    filename: json['filename'],
    type: json['type'],
    size: json['size'],
    uploadedById: json['uploadedById'],
    createdAt: json['createdAt'],
    uploadedBy: json['uploadedBy'] != null
        ? User.fromJson(json['uploadedBy'])
        : null,
  );
}
