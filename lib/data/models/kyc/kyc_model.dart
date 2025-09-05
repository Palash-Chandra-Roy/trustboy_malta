import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../logic/cubit/kyc/kyc_cubit.dart';

class KycModel extends Equatable {
  final KycItem? kyc;
  final List<KycItem>? kycType;

  const KycModel({this.kyc, this.kycType});

  KycModel copyWith({
    KycItem? kyc,
    List<KycItem>? kycType,
  }) {
    return KycModel(
      kyc: kyc ?? this.kyc,
      kycType: kycType ?? this.kycType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'kyc': kyc!.toMap(),
      'kycType': kycType!.map((x) => x.toMap()).toList(),
    };
  }

  factory KycModel.fromMap(Map<String, dynamic> map) {
    return KycModel(
      kyc: map['kyc'] != null
          ? KycItem.fromMap(map['kyc'] as Map<String, dynamic>)
          : null,
      kycType: map['kycType'] != null
          ? List<KycItem>.from(
              (map['kycType'] as List<dynamic>).map<KycItem>(
                (x) => KycItem.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory KycModel.fromJson(String source) =>
      KycModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [kyc, kycType];
}

// ignore: must_be_immutable
class KycItem extends Equatable {
  final int id;
  final int kycId;
  final int userId;
  final String name;
  final String file;
  final String message;
  final int status;
  final String createdAt;
  final String updatedAt;
  int initialPage;
  bool isListEmpty;
  final KycState kycState;

  KycItem({
    required this.id,
    required this.kycId,
    required this.userId,
    required this.name,
    this.file = '',
    this.initialPage = 1,
    this.isListEmpty = false,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.kycState = const KycInitial(),
  });

  KycItem copyWith({
    int? id,
    int? kycId,
    int? userId,
    String? name,
    String? file,
    String? message,
    int? status,
    int? initialPage,
    bool? isListEmpty,
    String? createdAt,
    String? updatedAt,
    KycState? kycState,
  }) {
    return KycItem(
      id: id ?? this.id,
      kycId: kycId ?? this.kycId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      file: file ?? this.file,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      kycState: kycState ?? this.kycState,
      initialPage: initialPage ?? this.initialPage,
      isListEmpty: isListEmpty ?? this.isListEmpty,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'kyc_id': kycId.toString(),
      'message': message,
    };
  }

  factory KycItem.fromMap(Map<String, dynamic> map) {
    return KycItem(
      id: map['id'] as int,
      kycId: map['kyc_id'] != null ? int.parse(map['kyc_id'].toString()) : 0,
      userId: map['user_id'] != null ? int.parse(map['user_id'].toString()) : 0,
      name: map['name'] ?? '',
      file: map['file'] ?? '',
      message: map['message'] ?? '',
      status: map['status'] != null ? int.parse(map['status'].toString()) : 0,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory KycItem.fromJson(String source) =>
      KycItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  static KycItem init() {
    return KycItem(
      id: 0,
      kycId: 0,
      userId: 0,
      name: '',
      file: '',
      message: '',
      status: 0,
      createdAt: '',
      updatedAt: '',
      kycState: const KycInitial(),
      initialPage: 1,
      isListEmpty: false,
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      kycId,
      userId,
      name,
      file,
      message,
      status,
      createdAt,
      updatedAt,
      kycState,
      initialPage,
      isListEmpty,
    ];
  }
}
