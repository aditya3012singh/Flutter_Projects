import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
import 'technician_model.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel {
  final String id;
  final String serviceType;
  final String serviceDate;
  final String? remarks;
  final String status;

  final UserModel? user;
  final TechnicianModel? technician;
  final ReportModel? report;

  BookingModel({
    required this.id,
    required this.serviceType,
    required this.serviceDate,
    this.remarks,
    required this.status,
    this.user,
    this.technician,
    this.report,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}

@JsonSerializable()
class ReportModel {
  final String id;
  final String summary;
  final String createdAt;

  ReportModel({
    required this.id,
    required this.summary,
    required this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}
