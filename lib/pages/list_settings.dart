import 'package:dailybudget/Model/settings_data_model.dart';
import 'package:dailybudget/bloc/limit_bloc.dart';
import 'package:dailybudget/bloc/limit_event.dart';
import 'package:dailybudget/bloc/limit_state.dart';
import 'package:dailybudget/bloc/list_bloc.dart';
import 'package:dailybudget/bloc/list_event.dart';
import 'package:dailybudget/bloc/list_state.dart';
import 'package:dailybudget/features/auth_service.dart';
import 'package:dailybudget/features/use_cloud.dart';
import 'package:dailybudget/l10n/app_localizations.dart';
import 'package:dailybudget/main.dart' show isPC;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListSettingsPage extends StatelessWidget {
  const ListSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          return ListSettingsView();
        }
      );
  }
}

class ListSettingsView extends StatefulWidget {
  const ListSettingsView({super.key});

  @override
  State<ListSettingsView> createState() => _ListSettingsViewState();
}

class _ListSettingsViewState extends State<ListSettingsView> {
  final _formKey = GlobalKey<FormState>();

  AppLocalizations? loc;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _useCloudController = ValueNotifier<bool>(false);
  final _logByEmailController = ValueNotifier<bool>(false);
  final _cloudController = ValueNotifier<CloudProvider>(FirebaseCloudProvider());

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _useCloudController.dispose();
    _logByEmailController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final settings = SettingsDataModel();
    settings.loadSettings();

    return BlocBuilder<LimitBloc, LimitState>(
      builder: (context, state) {

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_emailController.text != settings.email) {
            _emailController.text = settings.email;
          }
          if (_passwordController.text != settings.password) {
            _passwordController.text = settings.password;
          }
          _useCloudController.value = settings.useCloud;
          _logByEmailController.value = settings.logByEmail;
          _cloudController.value = settings.cloudProvider;
        });
        
        return Scaffold(
          appBar: AppBar(
            title: BlocBuilder<LimitBloc, LimitState>(
              builder: (context, state) {
                return Text(loc!.listSettingsTitle);
              },
            ),
            actions: [
              PopupMenuButton<Locale>(
                onSelected: (locale) {
                  context.read<LimitBloc>().add(ChangeLocaleEvent(locale));
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: Locale('en'),
                    child: Text('English'),
                  ),
                  const PopupMenuItem(
                    value: Locale('pl'),
                    child: Text('Polski'),
                  ),
                ],
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  CheckboxListTile(
                    title: Text(loc!.useCloud),
                    value: settings.useCloud,
                    onChanged: (value) async {
                      if (value != null){
                        settings.useCloud = value;
                        await settings.saveSettings();
                        setState((){});
                        if (value && !isPC()){
                          if (settings.cloudProvider is FirebaseCloudProvider) {
                            if (settings.logByEmail) {
                              await AuthService().signInWithEmail(settings.email, settings.password);
                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null && !user.emailVerified) {
                                await FirebaseAuth.instance.signOut();
                                settings.infoMessage = "Potwierdź email zanim się zalogujesz";
                                // Pokaż komunikat: "Potwierdź email zanim się zalogujesz"
                              }else{
                                if (user == null){
                                  settings.infoMessage = "Brak użytkownika";
                                }else{
                                  settings.infoMessage = "Email potwierdzony";
                                }
                              }
                            } else {
                              await AuthService().signInWithGoogle();
                            }
                          }
                        }
                      }
                    },
                  ),
                  if (settings.useCloud)
                    CheckboxListTile(
                      title: Text(loc.lbeLabel),
                      value: settings.logByEmail,
                      onChanged: (value) => context.read<ListBloc>().add(UpdateLogByEmailEvent(value ?? true)),
                    ),
                    _buildTextField(context, loc.email, _emailController,
                        (value) => settings.email = value),
                    _buildTextField(context, loc.password, _passwordController,
                        (value) => settings.password = value),
                    const SizedBox(height: 20),

                    DropdownButton<CloudProvider>(
                      value: settings.cloudProvider,
                      items: [
                        DropdownMenuItem(
                          value: FirebaseCloudProvider(),
                          child: Text(loc.firebaseCloud),
                        ),
                        DropdownMenuItem(
                          value: GoogleCloudProvider(),
                          child: Text(loc.googleCloud),
                        ),
                        DropdownMenuItem(
                          value: UserBackendCloudProvider(),
                          child: Text(loc.userCloud),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          settings.cloudProvider = value;
                          settings.saveSettings();
                          setState((){});
                        }
                      },
                    ),
                    Text(settings.infoMessage),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildTextField(BuildContext context, String label,
      TextEditingController controller, void Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        // keyboardType: const TextInputType.numberWithOptions(
        //   decimal: true,
        //   signed: true
        // ),
        // inputFormatters: [
        //   FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        // ],
        decoration: InputDecoration(
          labelText: label,
          // suffix: isInt ? Text("") : Text(_currency!),
          border: const OutlineInputBorder(),
        ),
        onFieldSubmitted: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) return loc!.enterValue;
          return double.tryParse(value) == null ? loc!.enterValue : null;
        },
      ),
    );
  }
}
