part of 'education_bloc.dart';

class EducationState extends Equatable {
  const EducationState({
    this.terms = const [],
    this.searchTerms = const [],
    this.signMains = const [],
    this.signs = const [],
    this.filterSigns = const [],
  });

  final List<TermModel> terms;
  final List<TermModel> searchTerms;
  final List<SignMainModel> signMains;
  final List<SignModel> signs;
  final List<SignModel> filterSigns;

  EducationState copyWith({
    List<TermModel>? terms,
    List<TermModel>? searchTerms,
    List<SignMainModel>? signMains,
    List<SignModel>? signs,
    List<SignModel>? filterSigns,
  }) {
    return EducationState(
      terms: terms ?? this.terms,
      searchTerms: searchTerms ?? this.searchTerms,
      signMains: signMains ?? this.signMains,
      signs: signs ?? this.signs,
      filterSigns: filterSigns ?? this.filterSigns,
    );
  }

  @override
  List<Object?> get props => [
        terms,
        searchTerms,
        signMains,
        signs,
        filterSigns,
      ];
}
