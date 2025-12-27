// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get alertDialogLess => 'Spendings are less than zero';

  @override
  String get alertDialogLessQestion => 'Update limits after income?';

  @override
  String get alertDialogMore => 'Spending are more than limit';

  @override
  String get alertDialogMoreQestion => 'Update limit or borrow from next days?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get update => 'Update';

  @override
  String get borrow => 'Borrow';

  @override
  String get overviewTitle => 'Overview';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get pln => 'zł';

  @override
  String get usd => '\$';

  @override
  String get enterSpending => 'Enter Spending';

  @override
  String get promptSttNotAvailable =>
      'Speech-to-text is not supported on this platform';

  @override
  String get send => 'Send';

  @override
  String get budget => 'Budget';

  @override
  String get maxLimit => 'Max limit';

  @override
  String get payDay => 'Pay day of month';

  @override
  String get limit => 'Limit';

  @override
  String get prompLimitUpdated => 'Limit updated';

  @override
  String get updateLimit => 'Update limit';

  @override
  String get enterValue => 'Enter value';

  @override
  String get enterInteger => 'Enter integer';

  @override
  String get enterNumber => 'Enter number';

  @override
  String get enterDay => '1 - 31';

  @override
  String get dailyBudget => 'Daily Budget';

  @override
  String get showLog => 'Show log';

  @override
  String get logViewer => 'Log Viewer';

  @override
  String get commonList => 'Common List';
}
