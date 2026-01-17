import 'package:dailybudget/Model/settings_data_model.dart';
import 'package:dailybudget/bloc/list_event.dart';
import 'package:dailybudget/bloc/list_state.dart';
import 'package:dailybudget/features/local_storage_service_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final LocalStorageServiceList _storageService;

  ListBloc(this._storageService) : super(ListState.initial()) {
    on<ToggleItemCheckEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      final itemsInCategory = newData.catItems[event.category];
      if (itemsInCategory != null && event.index >= 0 && event.index < itemsInCategory.length) {
        itemsInCategory[event.index].checked = !itemsInCategory[event.index].checked;
      }

      newData.updated = false;

      emit(state.copyWith(data: newData));
      await _storageService.saveToPreferences(newData);
    });

    on<LoadSettingsEvent>((event, emit) async {
      final newSettings = SettingsDataModel();
      await newSettings.loadSettings();

      emit(state.copyWith(settings: newSettings));
    });


    on<LoadListDataEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.updated = false;
      emit(state.copyWith(data: newData));
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


      newData.updated = false;
      emit(state.copyWith(data: newData));
    });

    on<AddItemEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.items.add(event.item);

      newData.updated = true;

      emit(state.copyWith(data: newData));
      await _storageService.saveToPreferences(newData);
    });

    on<EditItemEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      final itemsInCategory = newData.catItems[event.category];
      if (itemsInCategory != null && event.index >= 0 && event.index < itemsInCategory.length) {
        newData.catItems[event.category]![event.index].text = event.item.text;
        newData.catItems[event.category]![event.index].category = event.item.category;
      }

      newData.updated = true;
      
      emit(state.copyWith(data: newData));
      await _storageService.saveToPreferences(newData);
    });

    on<RemoveItemEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.items.removeAt(event.index);

      newData.updated = false;
      emit(state.copyWith(data: newData));
      await _storageService.saveToPreferences(newData);
    });

    on<SaveItemEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.items.add(event.item);

      newData.updated = false;
      emit(state.copyWith(data: newData));
      await _storageService.saveToPreferences(newData);
    });

    on<UpdateLogByEmailEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.updated = false;
      emit(state.copyWith(data: newData));
      await _storageService.saveToPreferences(newData);
    });

    on<UpdateCloudProviderEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.updated = false;
      emit(state.copyWith(data: newData));
      await _storageService.saveToPreferences(newData);
    });

    on<DeleteItemEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      final itemsInCategory = newData.catItems[event.category];
      if (itemsInCategory != null && event.index >= 0 && event.index < itemsInCategory.length) {
        final itemToRemove = itemsInCategory[event.index];
        newData.items.remove(itemToRemove);
      }

      newData.updated = true;

      emit(state.copyWith(data: newData));
      await _storageService.saveToPreferences(newData);
    });

    on<RemoveCheckedItemEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.items.removeWhere((item) => item.checked == true);


      newData.updated = false;
      emit(state.copyWith(data: newData));
      await _storageService.saveToPreferences(newData);
    });

    on<RemoveAllItemEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.items.clear();

      newData.updated = false;

      emit(state.copyWith(data: newData));
      await _storageService.saveToPreferences(newData);
    });

    _init();
  }

  void _init() {
    add(LoadListDataEvent());
  }
}