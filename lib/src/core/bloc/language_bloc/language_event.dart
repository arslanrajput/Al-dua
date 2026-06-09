part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}

class LanguageChanged extends LanguageEvent {
  final AppLanguage language;

  const LanguageChanged(this.language);

  @override
  List<Object> get props => [language];
}
