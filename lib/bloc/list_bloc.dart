import 'package:dailybudget/Model/list_data_model.dart';
import 'package:dailybudget/Model/settings_data_model.dart';
import 'package:dailybudget/bloc/list_event.dart';
import 'package:dailybudget/bloc/list_state.dart';
import 'package:dailybudget/features/local_storage_service_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final LocalStorageServiceList _storageService;

  ListBloc(this._storageService) : super(ListState(ListDataModel())){

    on<ToggleItemCheckEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      final itemsInCategory = newData.catItems[event.category];
      if (itemsInCategory != null && event.index >= 0 && event.index < itemsInCategory.length) {
        itemsInCategory[event.index].checked = !itemsInCategory[event.index].checked;
      }

      emit(ListState(newData));
      await _storageService.saveToPreferences(newData);
    });


    on<LoadListDataEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();
      emit(ListState(newData));
    });

    on<RefreshDarataEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();
      final settings = SettingsDataModel();
      settings.loadSettings();

      await settings.cloudProvider.fetchData('shoppingLists', settings.email).then((data) {
          // setState(() {
          //   if (data.isNotEmpty) {
          //     if (data[0]["Error"]!= null) {
          //       _items = [];
          //       settings.infoMessage = "Potwierdź email zanim się zalogujesz";
          //     } else if (data[0]['items'] != null) {
          //       _items = List<Map<String, dynamic>>.from(data[0]['items']);
          //     } else {
          //       _items = [];
          //     }
          //   } else {
          //     _items = [];
          //   }
          // });
        });

      
      emit(ListState(newData));
    });

    on<AddItemEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.items.add(event.item);

      emit(ListState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<RemoveItemEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.items.removeAt(event.index);

      emit(ListState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<SaveItemEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.items.add(event.item);

      emit(ListState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<UpdateLogByEmailEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      emit(ListState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<UpdateCloudProviderEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      emit(ListState(newData));
      await _storageService.saveToPreferences(newData);
    });

    _init();
  }

  void _init() {
    add(LoadListDataEvent());
  }
}