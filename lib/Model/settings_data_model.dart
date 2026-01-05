import 'package:dailybudget/features/use_cloud.dart';
import 'package:dailybudget/l10n/app_localizations.dart';
import 'package:dailybudget/l10n/app_localizations_en.dart';
import 'package:dailybudget/l10n/app_localizations_pl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDataModel {
  String infoMessage = "";
  bool useCloud = false;
  bool logByEmail = true;
  String email = "";
  String password = "";
  CloudProvider cloudProvider = FirebaseCloudProvider();
  String locLanguageCode = 'pl';
  AppLocalizations? loc;

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    infoMessage = prefs.getString('infoMessage') ?? "";
    useCloud = prefs.getBool('useCloud') ?? false;
    logByEmail = prefs.getBool('logByEmail') ?? true;
    email = prefs.getString('email') ?? "";
    password = prefs.getString('password') ?? "";
    String cloudProviderName = prefs.getString('cloudProvider') ?? 'Firebase';
    switch (cloudProviderName) {
      case 'Firebase':
        cloudProvider = FirebaseCloudProvider();
        break;
      case 'Google':
        cloudProvider = GoogleCloudProvider();
        break;
      case 'UserBackend':
        cloudProvider = UserBackendCloudProvider();
        break;
      default:
        cloudProvider = FirebaseCloudProvider();
    }
    locLanguageCode = prefs.getString('locLanguageCode') ?? 'pl';
    switch (locLanguageCode) {
      case 'pl':
        loc = AppLocalizationsPl();
        break;
      case 'en':
        loc = AppLocalizationsEn();
        break;
      default:
        loc = AppLocalizationsPl();
    }
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('infoMessage', infoMessage);
    await prefs.setBool('useCloud', useCloud);
    await prefs.setBool('logByEmail', logByEmail);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('cloudProvider', cloudProvider.name);
  }

}