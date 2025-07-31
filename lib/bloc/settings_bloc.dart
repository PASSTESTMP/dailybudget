import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dailybudget/Model/data_model.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final DataModel _dataModel = DataModel();

  SettingsCubit() : super(SettingsState.initial()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));
    final prefs = await SharedPreferences.getInstance();
    _dataModel.getFromPreferences(prefs);

    emit(SettingsState(
      budget: _dataModel.budget,
      maxLimit: _dataModel.maxLimit,
      payday: _dataModel.payday,
      borrow: _dataModel.borrow,
      limit: _dataModel.limit,
      isLoading: false,
    ));
  }

  void updateBudget(String value) {
    final parsed = double.tryParse(value) ?? 0;
    emit(state.copyWith(budget: parsed));
  }

  void updateMaxLimit(String value) {
    final parsed = double.tryParse(value) ?? 0;
    emit(state.copyWith(maxLimit: parsed));
  }

  void updatePayday(String value) {
    final parsed = int.tryParse(value) ?? 1;
    emit(state.copyWith(payday: parsed));
  }

  void updateBorrow(String value) {
    final parsed = double.tryParse(value) ?? 0;
    emit(state.copyWith(borrow: parsed));
  }

  void updateLimit(String value) {
    final parsed = double.tryParse(value) ?? 0;
    emit(state.copyWith(limit: parsed));
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _dataModel.budget = state.budget;
    _dataModel.maxLimit = state.maxLimit;
    _dataModel.payday = state.payday;
    _dataModel.borrow = state.borrow;
    _dataModel.limit = state.limit;
    _dataModel.lastUpdate = DateTime.now();

    await _dataModel.saveToPreferences(prefs);
  }
}
