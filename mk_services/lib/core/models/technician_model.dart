import 'package:json_annotation/json_annotation.dart';

part 'technician_model.g.dart';

@JsonSerializable()
class TechnicianModel {
  final String id;
  final String name;
  final String phone;
  final String? location;
  final int totalJobs;

  TechnicianModel({
    required this.id,
    required this.name,
    required this.phone,
    this.location,
    required this.totalJobs,
  });

  factory TechnicianModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianModelFromJson(json);

  Map<String, dynamic> toJson() => _$TechnicianModelToJson(this);
}
