import 'package:dailybudget/Model/list_data_model.dart';
import 'package:dailybudget/Model/settings_data_model.dart';

class ListState {
  final ListDataModel data;
  final SettingsDataModel settings;

  const ListState({
    required this.data,
    required this.settings,
  });

  static ListState initial() => ListState(
    data: ListDataModel.initial(),
    settings: SettingsDataModel.initial(),
  );

  ListState copyWith({
    ListDataModel? data,
    SettingsDataModel? settings,
  }) {
    return ListState(
      data: data ?? this.data,
      settings: settings ?? this.settings,
    );
  }
}