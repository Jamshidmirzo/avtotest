part of 'education_bloc.dart';

class EducationEvent extends Equatable {
  const EducationEvent();

  @override
  List<Object?> get props => [];
}

class ParseTermsEvent extends EducationEvent {
  const ParseTermsEvent();
}

class ParseSignMainsEvent extends EducationEvent {
  const ParseSignMainsEvent();
}

class ParseSignsEvent extends EducationEvent {
  const ParseSignsEvent();
}

class InitializeTermsEvent extends EducationEvent {
  const InitializeTermsEvent();
}

class SearchTermsEvent extends EducationEvent {
  const SearchTermsEvent({required this.searchText});

  final String searchText;
}

class GetSignById extends EducationEvent {
  final String id;
  const GetSignById({required this.id});
}
