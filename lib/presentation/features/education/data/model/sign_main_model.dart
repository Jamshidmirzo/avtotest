import 'package:equatable/equatable.dart';

class SignMainModel extends Equatable {
  final String id;
  final String nameUz;
  final String nameLa;
  final String nameRu;
  final String media;

  const SignMainModel({
    this.id = "",
    this.nameUz = "",
    this.nameLa = "",
    this.nameRu = "",
    this.media = "",
  });

  factory SignMainModel.fromJson(Map<String, dynamic> json) {
    return SignMainModel(
      id: json['id'] ?? "",
      nameUz: json['name_uz'] ?? "",
      nameLa: json['name_la'] ?? "",
      nameRu: json['name_ru'] ?? "",
      media: json['media'] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        id,
        nameUz,
        nameLa,
        nameRu,
        media,
      ];
}
