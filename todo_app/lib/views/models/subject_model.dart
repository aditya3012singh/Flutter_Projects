class Subject {
  final String id;
  final String name;
  final String branch;
  final int semester;

  Subject({
    required this.id,
    required this.name,
    required this.branch,
    required this.semester,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: json['id'],
    name: json['name'],
    branch: json['branch'],
    semester: json['semester'],
  );
}
