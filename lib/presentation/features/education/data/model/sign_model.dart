import 'package:equatable/equatable.dart';

class SignModel extends Equatable {
  final int id;
  final int groupId;
  final String signNumber;
  final String signNameLa;
  final String signNameUz;
  final String signNameRu;
  final String signImage;
  final String descriptionLa;
  final String descriptionUz;
  final String descriptionRu;

  const SignModel({
    this.id = -1,
    this.groupId = -1,
    this.signNumber = "",
    this.signNameLa = "",
    this.signNameUz = "",
    this.signNameRu = "",
    this.signImage = "",
    this.descriptionLa = "",
    this.descriptionUz = "",
    this.descriptionRu = "",
  });

  factory SignModel.fromJson(Map<String, dynamic> json) {
    return SignModel(
      id: json['id'] ?? -1,
      groupId: json['group_id'] ?? -1,
      signNumber: json['sign_number'] ?? "",
      signNameLa: json['sign_name_la'] ?? "",
      signNameUz: json['sign_name_uz'] ?? "",
      signNameRu: json['sign_name_ru'] ?? "",
      signImage: json['sign_image'] ?? "",
      descriptionLa: json['description_la'] ?? "",
      descriptionUz: json['description_uz'] ?? "",
      descriptionRu: json['description_ru'] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        id,
        groupId,
        signNumber,
        signNameLa,
        signNameUz,
        signNameRu,
        signImage,
        descriptionLa,
        descriptionUz,
        descriptionRu,
      ];
}
