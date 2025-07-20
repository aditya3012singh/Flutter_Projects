class Note {
  final String id;
  final String title;
  final String branch;
  final int semester;
  final String fileUrl;
  final String subjectId;
  final String uploadedById;
  final String? approvedById;
  final String createdAt;
  final Map<String, dynamic>? subject;
  final Map<String, dynamic>? uploadedBy;
  final Map<String, dynamic>? approvedBy;

  Note({
    required this.id,
    required this.title,
    required this.branch,
    required this.semester,
    required this.fileUrl,
    required this.subjectId,
    required this.uploadedById,
    this.approvedById,
    required this.createdAt,
    this.subject,
    this.uploadedBy,
    this.approvedBy,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      branch: json['branch'],
      semester: json['semester'],
      fileUrl: json['fileUrl'],
      subjectId: json['subjectId'],
      uploadedById: json['uploadedById'],
      approvedById: json['approvedById'],
      createdAt: json['createdAt'],
      subject: json['subject'],
      uploadedBy: json['uploadedBy'],
      approvedBy: json['approvedBy'],
    );
  }
}
