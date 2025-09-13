class TermModel {
  String definitionUz;
  String definitionLa;
  String definitionRu;
  String termUz;
  String termLa;

  TermModel({
    this.definitionUz = "",
    this.definitionLa = "",
    this.definitionRu = "",
    this.termUz = "",
    this.termLa = "",
  });

  factory TermModel.fromJson(Map<String, dynamic> json) {
    return TermModel(
      definitionUz: json['definition_uz'] ?? "",
      definitionLa: json['definition_la'] ?? "",
      definitionRu: json['definition_ru'] ?? "",
      termUz: json['term_uz'] ?? "",
      termLa: json['term_la'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'definition_uz': definitionUz,
      'definition_la': definitionLa,
      'definition_ru': definitionRu,
      'term_uz': termUz,
      'term_la': termLa,
    };
  }
}
