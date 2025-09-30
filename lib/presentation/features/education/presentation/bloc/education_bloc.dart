import 'dart:convert';
import 'package:avtotest/content/atamalar.dart';
import 'package:avtotest/content/signItems.dart';
import 'package:avtotest/content/signs.dart';
import 'package:avtotest/presentation/features/education/data/model/sign_main_model.dart';
import 'package:avtotest/presentation/features/education/data/model/sign_model.dart';
import 'package:avtotest/presentation/features/education/data/model/term_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

part 'education_event.dart';
part 'education_state.dart';

class EducationBloc extends Bloc<EducationEvent, EducationState> {
  EducationBloc() : super(EducationState()) {
    on<ParseTermsEvent>(_parseTermsEvent);
    on<SearchTermsEvent>(_searchTermsEvent);
    on<InitializeTermsEvent>(_initialTermsEvent);
    on<ParseSignMainsEvent>(_parseSignMainsEvent);
    on<ParseSignsEvent>(_parseSignsEvent);
    on<GetSignById>(_getSignById);
  }

  Future<void> _parseTermsEvent(
    ParseTermsEvent event,
    Emitter<EducationState> emit,
  ) async {
    // Берём данные напрямую из глобального списка
    List<TermModel> terms =
        atamalarGlobal.map((e) => TermModel.fromJson(e)).toList();

    emit(state.copyWith(
      terms: terms,
      searchTerms: terms,
    ));
  }

  Future<void> _searchTermsEvent(
    SearchTermsEvent event,
    Emitter<EducationState> emit,
  ) async {
    if (event.searchText.isEmpty) {
      emit(state.copyWith(searchTerms: state.terms));
      return;
    }
    final List<TermModel> searchTerms = state.terms
        .where((term) =>
            term.termLa.toLowerCase().contains(event.searchText.toLowerCase()))
        .toList();
    emit(state.copyWith(searchTerms: searchTerms));
  }

  Future<void> _initialTermsEvent(
    InitializeTermsEvent event,
    Emitter<EducationState> emit,
  ) async {
    emit(state.copyWith(searchTerms: state.terms));
  }

  Future<void> _parseSignMainsEvent(
    ParseSignMainsEvent event,
    Emitter<EducationState> emit,
  ) async {
    try {
      // Используем глобальный список
      List<SignMainModel> signMains =
          signsGlobal.map((e) => SignMainModel.fromJson(e)).toList();

      emit(state.copyWith(signMains: signMains));
    } catch (e) {
      debugPrint('Error parsing sign mains: $e');
      emit(state.copyWith(signMains: <SignMainModel>[]));
    }
  }

  Future<void> _parseSignsEvent(
    ParseSignsEvent event,
    Emitter<EducationState> emit,
  ) async {
    try {
      // Берём данные напрямую из Dart-списка
      List<SignModel> signs =
          signItemsGlobal.map((e) => SignModel.fromJson(e)).toList();

      // сортировка по номеру знака
      signs.sort((a, b) => a.signNumber.compareTo(b.signNumber));

      emit(state.copyWith(signs: signs));
    } catch (e) {
      debugPrint('Error parsing signs: $e');
      emit(state.copyWith(signs: <SignModel>[]));
    }
  }

  Future<void> _getSignById(
    GetSignById event,
    Emitter<EducationState> emit,
  ) async {
    final List<SignModel> filteredSigns = state.signs
        .where((sign) => sign.groupId.toString() == event.id)
        .toList();
    if (filteredSigns.isNotEmpty) {
      emit(state.copyWith(filterSigns: filteredSigns));
    } else {
      emit(state.copyWith(filterSigns: []));
    }
  }
}
