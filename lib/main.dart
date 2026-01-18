import 'package:dailybudget/Model/data_model.dart';
import 'package:dailybudget/Model/list_data_model.dart';
import 'package:dailybudget/Model/settings_data_model.dart';
import 'package:dailybudget/bloc/limit_bloc.dart';
import 'package:dailybudget/bloc/limit_event.dart';
import 'package:dailybudget/bloc/limit_state.dart';
import 'package:dailybudget/bloc/list_bloc.dart';
import 'package:dailybudget/bloc/list_event.dart';
import 'package:dailybudget/features/auth_service.dart';
import 'package:dailybudget/features/local_storage_service.dart';
import 'package:dailybudget/features/local_storage_service_list.dart';
import 'package:dailybudget/firebase_options.dart';
import 'package:dailybudget/l10n/app_localizations.dart';
import 'package:dailybudget/pages/overview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';

bool isPC() {
  // Tylko jeśli nie jesteśmy w przeglądarce
  if (!kIsWeb) {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }
  return false; // Web to nie PC natywny
}

Future<void> main() async {
  // Ensure that the Flutter engine is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsDataModel();
  await settings.loadSettings();

  if (settings.useCloud && !isPC()){
    try{
      await settings.cloudProvider.initialize();
    } catch (e) {
      settings.infoMessage = "Error signing in1: $e";
    }
    try{
      if (settings.cloudProvider.name == "Firebase") {
        if (settings.logByEmail) {
          await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
          await AuthService().signInWithEmail(settings.email, settings.password);
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null && !user.emailVerified) {
            await FirebaseAuth.instance.signOut();
            settings.infoMessage = "Potwierdź email zanim się zalogujesz";
            // Pokaż komunikat: "Potwierdź email zanim się zalogujesz"
          }else{
            settings.infoMessage = "";
          }
        } else {
          await AuthService().signInWithGoogle();
        }
      }
    } catch (e) {
      String last = settings.infoMessage;
      settings.infoMessage = "Error signing in2: $e\n$last";
    }
  }
  settings.saveSettings();

  // debugPaintSizeEnabled = true;

  // Set the minimum window size for desktop platforms
  if (isPC()) {
    setWindowMinSize(const Size(600, 800));
  }else {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(
    MultiBlocProvider(
      providers: [
      BlocProvider(
        create: (_) => LimitBloc(LocalStorageService(DataModel()))..add(LoadDataEvent()),
      ),
      BlocProvider(
        create: (_) => ListBloc(LocalStorageServiceList(ListDataModel()))..add(LoadListDataEvent()),
      ),
      ],
      child: const DailyBudgetApp(),
    )
  );
}

class DailyBudgetApp extends StatelessWidget {
  const DailyBudgetApp({super.key});

  final ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LimitBloc, LimitState>(
      builder: (context, state) {
        return MaterialApp(
          locale: state.dataModel.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('pl'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          title: 'Daily Budget',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white70),
              bodyLarge: TextStyle(color: Colors.white70),
              bodySmall: TextStyle(color: Colors.white54),
            ),
            scaffoldBackgroundColor: const Color.fromARGB(255, 39, 39, 39),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 104, 127, 146),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: _themeMode,
          home: OverviewPage(),
        );
      }
    );
  }
}