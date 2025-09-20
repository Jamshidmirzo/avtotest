import 'dart:convert';
import 'package:avtotest/presentation/features/education/data/model/sign_main_model.dart';
import 'package:avtotest/presentation/features/education/data/model/sign_model.dart';
import 'package:avtotest/presentation/features/education/data/model/term_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    final String response =
        await rootBundle.loadString('lib/content/atamalar.json');
    // final List<dynamic> data1 = await MyFunctions.decryptFile(
    //   inputFilePath: 'assets/content/encrypted_output1.txt',
    //   keyBase64: dotenv.get("KEY"),
    //   ivBase64: dotenv.get("IV1"),
    // );
    final List<dynamic> atamalarRes = jsonDecode(response);

    List<TermModel> terms =
        atamalarRes.map((e) => TermModel.fromJson(e)).toList();
    emit(state.copyWith(terms: terms, searchTerms: terms));
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
    // final List<dynamic> data4 = await MyFunctions.decryptFile(
    //   inputFilePath: 'assets/content/encrypted_output4.txt',
    //   keyBase64: dotenv.get("KEY"),
    //   ivBase64: dotenv.get("IV4"),
    // );
    final String response =
        await rootBundle.loadString('lib/content/signs.json');
    final List<dynamic> signsRes = jsonDecode(response);

    List<SignMainModel> signMains =
        signsRes.map((e) => SignMainModel.fromJson(e)).toList();
    emit(state.copyWith(signMains: signMains));
  }

  Future<void> _parseSignsEvent(
    ParseSignsEvent event,
    Emitter<EducationState> emit,
  ) async {
    // final List<dynamic> data5 = await MyFunctions.decryptFile(
    //   inputFilePath: 'assets/content/encrypted_output5.txt',
    //   keyBase64: dotenv.get("KEY"),
    //   ivBase64: dotenv.get("IV5"),
    // );
    final String response =
        await rootBundle.loadString('lib/content/signItems.json');
    final List<dynamic> signItemsRes = jsonDecode(response);

    List<SignModel> signs =
        signItemsRes.map((e) => SignModel.fromJson(e)).toList();
    signs.sort((a, b) => a.signNumber.compareTo(b.signNumber));
    emit(state.copyWith(signs: signs));
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
