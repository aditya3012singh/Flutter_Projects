class Event {
  final String id;
  final String title;
  final String content;
  final String eventDate;
  final String createdAt;

  Event({
    required this.id,
    required this.title,
    required this.content,
    required this.eventDate,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    eventDate: json['eventDate'],
    createdAt: json['createdAt'],
  );
}
