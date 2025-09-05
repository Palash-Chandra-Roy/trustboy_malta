import 'dart:convert';

import 'package:equatable/equatable.dart';

class MethodModel extends Equatable {
  final int id;
  final String name;
  final double minAmount;
  final double maxAmount;
  final double withdrawCharge;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;

  const MethodModel({
    required this.id,
    required this.name,
    required this.minAmount,
    required this.maxAmount,
    required this.withdrawCharge,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  MethodModel copyWith({
    int? id,
    String? name,
    double? minAmount,
    double? maxAmount,
    double? withdrawCharge,
    String? description,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return MethodModel(
      id: id ?? this.id,
      name: name ?? this.name,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      withdrawCharge: withdrawCharge ?? this.withdrawCharge,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'min_amount': minAmount,
      'max_amount': maxAmount,
      'withdraw_charge': withdrawCharge,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory MethodModel.fromMap(Map<String, dynamic> json) {
    return MethodModel(
      id: json['id'] ?? 0,
      name: json['method_name'] ?? '',
      minAmount: json['min_amount'] != null
          ? double.parse(json['min_amount'].toString().replaceAll(',', ''))
          : 0.0,
      maxAmount: json['max_amount'] != null
          ? double.parse(json['max_amount'].toString().replaceAll(',', ''))
          : 0.0,
      withdrawCharge: json['withdraw_charge'] != null
          ? double.parse(json['withdraw_charge'].toString().replaceAll(',', ''))
          : 0.0,
      description: json['description'] ?? '',
      status: json['status'] ??'',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MethodModel.fromJson(String source) =>
      MethodModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  static MethodModel init(){
    return const MethodModel(
      id : 0,
      name : '',
      minAmount : 0,
      maxAmount : 0,
      withdrawCharge : 0,
      description : '',
      status : '',
      createdAt : '',
      updatedAt : '',
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      minAmount,
      maxAmount,
      withdrawCharge,
      description,
      status,
      createdAt,
      updatedAt,
    ];
  }
}
