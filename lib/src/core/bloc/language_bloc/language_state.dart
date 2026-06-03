part of 'language_bloc.dart';

class LanguageState extends Equatable {
  final AppLanguage selectedLanguage;

  const LanguageState({this.selectedLanguage = AppLanguage.english});

  LanguageState copyWith({
    AppLanguage? selectedLanguage,
  }) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object> get props => [selectedLanguage];
}
