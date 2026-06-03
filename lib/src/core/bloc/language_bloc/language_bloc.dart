import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:al_dua/src/core/util/model/language_model.dart';

part 'language_state.dart';
part 'language_event.dart';

class LanguageBloc extends HydratedBloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState()) {
    on<LanguageChanged>(_onLanguageChanged);
  }

  void _onLanguageChanged(LanguageChanged event, Emitter<LanguageState> emit) {
    emit(state.copyWith(selectedLanguage: event.language));
  }

  @override
  LanguageState fromJson(Map<String, dynamic> json) {
    return LanguageState(
      selectedLanguage: AppLanguage.fromCode(json['selectedLanguage'] as String?),
    );
  }

  @override
  Map<String, dynamic> toJson(LanguageState state) {
    return {
      'selectedLanguage': state.selectedLanguage.code,
    };
  }
}
