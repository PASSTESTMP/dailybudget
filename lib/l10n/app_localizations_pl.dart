// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get alertDialogLess => 'Wydatek jest ujemny';

  @override
  String get alertDialogLessQestion =>
      'Odświerzyć limit po wpływie do budżetu?';

  @override
  String get alertDialogMore => 'Wydatek jest większy niż limit';

  @override
  String get alertDialogMoreQestion =>
      'Odświerzyć limit czy pożyczyć z kolejnego dnia?';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get update => 'Odświerz';

  @override
  String get borrow => 'Pożycz';

  @override
  String get overviewTitle => 'Budżet dzienny';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get pln => 'zł';

  @override
  String get usd => '\$';

  @override
  String get enterSpending => 'Wpisz kwotę wydatku';

  @override
  String get promptSttNotAvailable =>
      'Speech-to-text jest nieobsługiwany przez platformę';

  @override
  String get send => 'Wyślij';

  @override
  String get budget => 'Budżet';

  @override
  String get maxLimit => 'Maksymalny limit';

  @override
  String get payDay => 'Dzień wypłaty';

  @override
  String get limit => 'Limit';

  @override
  String get prompLimitUpdated => 'Limit odświerzony';

  @override
  String get updateLimit => 'Odświerz limit';

  @override
  String get enterValue => 'Wpisz wartość';

  @override
  String get enterInteger => 'Wpisz wartość';

  @override
  String get enterNumber => 'Wpisz wartość';

  @override
  String get enterDay => '1 - 31';

  @override
  String get dailyBudget => 'Dzienny Budżet';

  @override
  String get showLog => 'Historia';

  @override
  String get logViewer => 'Historia';
}
