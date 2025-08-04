import 'package:dailybudget/Model/data_model.dart';
import 'package:dailybudget/bloc/limit_bloc.dart';
import 'package:dailybudget/bloc/limit_event.dart';
import 'package:dailybudget/bloc/limit_state.dart';
import 'package:dailybudget/features/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LimitBloc(LocalStorageService(DataModel()))..add(LoadDataEvent()),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
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
          appBar: AppBar(title: const Text('Settings')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildNumberField(context, 'Budget', _budgetController,
                      (value) => context.read<LimitBloc>().add(UpdateBudgetEvent(value))),
                  _buildNumberField(context, 'Max limit', _maxLimitController,
                      (value) => context.read<LimitBloc>().add(UpdateMaxLimitEvent(value))),
                  _buildNumberField(context, 'Pay day of month', _paydayController,
                      (value) => context.read<LimitBloc>().add(UpdatePaydayEvent(value)),
                      isInt: true),
                  _buildNumberField(context, 'Limit', _limitController,
                      (value) => context.read<LimitBloc>().add(UpdateLimitValueEvent(value))),
                  // const SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     if (_formKey.currentState!.validate()) {
                  //       context.read<LimitBloc>().add(SaveSettingsEvent(state.dataModel));
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         const SnackBar(content: Text('Settings saved')),
                  //       );
                  //     }
                  //   },
                  //   child: const Text('Save'),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumberField(BuildContext context, String label,
      TextEditingController controller, void Function(String) onChanged,
      {bool isInt = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: label,
          suffix: isInt ? Text("") : Text("zł"),
          border: const OutlineInputBorder(),
        ),
        onFieldSubmitted: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Enter value';
          return isInt
              ? (int.tryParse(value) == null ? 'Enter integer' : null)
              : (double.tryParse(value) == null ? 'Enter number' : null);
        },
      ),
    );
  }
}
