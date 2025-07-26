import 'package:json_annotation/json_annotation.dart';

part 'stock_model.g.dart';

@JsonSerializable()
class StockModel {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  StockModel({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) =>
      _$StockModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockModelToJson(this);
}
