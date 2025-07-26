// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TechnicianModel _$TechnicianModelFromJson(Map<String, dynamic> json) =>
    TechnicianModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      location: json['location'] as String?,
      totalJobs: (json['totalJobs'] as num).toInt(),
    );

Map<String, dynamic> _$TechnicianModelToJson(TechnicianModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'location': instance.location,
      'totalJobs': instance.totalJobs,
    };
