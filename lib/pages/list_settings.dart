import 'package:dailybudget/bloc/limit_bloc.dart';
import 'package:dailybudget/bloc/limit_event.dart';
import 'package:dailybudget/bloc/limit_state.dart';
import 'package:dailybudget/bloc/list_bloc.dart';
import 'package:dailybudget/bloc/list_state.dart';
import 'package:dailybudget/l10n/app_localizations.dart';
import 'package:dailybudget/pages/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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


  final _budgetController = TextEditingController();
  final _maxLimitController = TextEditingController();
  final _paydayController = TextEditingController();
  final _borrowController = TextEditingController();
  final _limitController = TextEditingController();

  @override
  void dispose() {
    _budgetController.dispose();
    _maxLimitController.dispose();
    _paydayController.dispose();
    _borrowController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  void _openLog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LogPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return BlocBuilder<LimitBloc, LimitState>(
      builder: (context, state) {

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_budgetController.text != state.dataModel.budget.toStringAsFixed(2)) {
            _budgetController.text = state.dataModel.budget.toStringAsFixed(2);
          }
          if (_maxLimitController.text != state.dataModel.maxLimit.toStringAsFixed(2)) {
            _maxLimitController.text = state.dataModel.maxLimit.toStringAsFixed(2);
          }
          if (_paydayController.text != state.dataModel.payday.toString()) {
            _paydayController.text = state.dataModel.payday.toString();
          }
          if (_limitController.text != state.dataModel.limit.toStringAsFixed(2)) {
            _limitController.text = state.dataModel.limit.toStringAsFixed(2);
          }
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

                  _buildTextField(context, loc!.email, _emailController,
                      (value) => context.read<ListBloc>().add(UpdateEmailEvent(value))),
                  _buildTextField(context, loc!.password, _passwordController,
                      (value) => context.read<ListBloc>().add(UpdatePasswordEvent(value))),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        context.read<LimitBloc>().add(UpdateLimitEvent(0.0));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(loc.prompLimitUpdated)),
                        );
                      }
                    },
                    child: Text(loc.update),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: _currencyController,
                    items: [
                      loc.pln,
                      loc.usd, 'EUR'].map((currency) {
                      return DropdownMenuItem(value: currency, child: Text(currency));
                    }).toList(),
                    onChanged: (value) => context.read<ListBloc>().add(UpdateCurrencyEvent(value)),
                  ),
                  CheckboxListTile(
                    title: Text('Log by email'),
                    value: _logByEmailController,
                    onChanged: (value) => context.read<ListBloc>().add(UpdateLogByEmailEvent(value)),
                  ),
                  CheckboxListTile(
                    title: Text('Use Cloud'),
                    value: _useCloudController,
                    onChanged: (value) async {
                      if (value != null){
                        context.read<SettingsModel>().setUseCloud(value);
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
                    DropdownButton<CloudProvider>(
                      value: _cloudController,
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
                          child: Text(loc.userBackend),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) context.read<SettingsModel>().setCloudProvider(value);
                      },
                    ),
                    Text(_infoMessageController),
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
