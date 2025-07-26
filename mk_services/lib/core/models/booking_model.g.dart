// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: json['id'] as String,
  serviceType: json['serviceType'] as String,
  serviceDate: json['serviceDate'] as String,
  remarks: json['remarks'] as String?,
  status: json['status'] as String,
  user: json['user'] == null
      ? null
      : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  technician: json['technician'] == null
      ? null
      : TechnicianModel.fromJson(json['technician'] as Map<String, dynamic>),
  report: json['report'] == null
      ? null
      : ReportModel.fromJson(json['report'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceType': instance.serviceType,
      'serviceDate': instance.serviceDate,
      'remarks': instance.remarks,
      'status': instance.status,
      'user': instance.user,
      'technician': instance.technician,
      'report': instance.report,
    };

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
  id: json['id'] as String,
  summary: json['summary'] as String,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'summary': instance.summary,
      'createdAt': instance.createdAt,
    };
