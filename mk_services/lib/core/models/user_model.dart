class UserModel {
  final String? id;
  final String name;
  final String email;
  final String? phone;
  final String? location;
  final String? role;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.location,
    this.role,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        return DateTime.parse(dateStr); // handles ISO (2025-07-26T12:34:56Z)
      } catch (_) {
        return null; // avoid crashing on bad format
      }
    }

    return UserModel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      location: json['location'],
      role: json['role'],
      createdAt: parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
