import 'package:dailybudget/Model/list_data_model.dart';
import 'package:dailybudget/Model/settings_data_model.dart';
import 'package:dailybudget/bloc/list_event.dart';
import 'package:dailybudget/bloc/list_state.dart';
import 'package:dailybudget/features/local_storage_service_list.dart';
import 'package:dailybudget/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final LocalStorageServiceList _storageService;

  ListBloc(this._storageService) : super(ListState.initial()) {
    

    Future<ListDataModel> syncWithCloud() async {
      ListDataModel newData =  ListDataModel.initial();

      final settings = SettingsDataModel();
      await settings.loadSettings();

      bool useCloud = state.settings.useCloud;
      if (useCloud && !isPC()) {
        await settings.cloudProvider.fetchData('shoppingLists', settings.email).then((data) {
          if (data.isNotEmpty) {
            if (data[0]["Error"]!= null) {
              settings.infoMessage = "Potwierdź email zanim się zalogujesz";
            } else {
              newData = listDataModelFromJson(data[0]);
            }
          }
        });

        await _storageService.saveToPreferences(newData);
      } else {
        newData = await _storageService.getFromPreferences();
      }
      return newData;
    }

    Future<void> saveNewData(ListDataModel newData) async {
      final settings = SettingsDataModel();
      await settings.loadSettings();

      bool useCloud = state.settings.useCloud;
      if (useCloud && !isPC()) {
        await state.settings.cloudProvider.uploadData('shoppingLists', listDataModelToJson(newData));
      }

      await _storageService.saveToPreferences(newData);
    }

    on<ToggleItemCheckEvent>((event, emit) async {
      final newData = await syncWithCloud();

      final itemsInCategory = newData.catItems[event.category];
      if (itemsInCategory != null && event.index >= 0 && event.index < itemsInCategory.length) {
        itemsInCategory[event.index].checked = !itemsInCategory[event.index].checked;
      }

      newData.updated = false;

      emit(state.copyWith(data: newData));
      
      await saveNewData(newData);
    });

    on<LoadSettingsEvent>((event, emit) async {
      final settings = SettingsDataModel();
      await settings.loadSettings();

      final newData = await _storageService.getFromPreferences();

      newData.id = settings.email;
      newData.ownerId = settings.email;

      emit(state.copyWith(settings: settings));
      emit(state.copyWith(data: newData));

      await _storageService.saveToPreferences(newData);
    });


    on<LoadListDataEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();
      final newSettings = SettingsDataModel();
      await newSettings.loadSettings();

      newData.id = newSettings.email;
      newData.ownerId = newSettings.email;

      newData.updated = false;
      emit(state.copyWith(data: newData));

      await _storageService.saveToPreferences(newData);
    });

    on<RefreshDarataEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();
      ListDataModel newDataFromCloud = ListDataModel.initial();
      final settings = SettingsDataModel();
      await settings.loadSettings();

      bool useCloud = state.settings.useCloud;
      if (useCloud && !isPC()) {
        await settings.cloudProvider.fetchData('shoppingLists', settings.email).then((data) {
          if (data.isNotEmpty) {
            if (data[0]["Error"]!= null) {
              settings.infoMessage = "Potwierdź email zanim się zalogujesz";
            } else {
              newDataFromCloud = listDataModelFromJson(data[0]);
            }
          }
        });

        await _storageService.saveToPreferences(newDataFromCloud);
        emit(state.copyWith(data: newDataFromCloud));
      } else {
        newData.updated = false;
        emit(state.copyWith(data: newData));
      }
    });

    on<AddItemEvent>((event, emit) async {
      final newData = await syncWithCloud();

      newData.items.add(event.item);

      newData.updated = true;

      emit(state.copyWith(data: newData));
      await saveNewData(newData);
    });

    on<EditItemEvent>((event, emit) async {
      final newData = await syncWithCloud();

      final itemsInCategory = newData.catItems[event.category];
      if (itemsInCategory != null && event.index >= 0 && event.index < itemsInCategory.length) {
        newData.catItems[event.category]![event.index].text = event.item.text;
        newData.catItems[event.category]![event.index].category = event.item.category;
      }

      newData.updated = true;
      
      emit(state.copyWith(data: newData));
      await saveNewData(newData);
    });

    on<RemoveItemEvent>((event, emit) async {
      final newData = await syncWithCloud();

      newData.items.removeAt(event.index);

      newData.updated = false;
      emit(state.copyWith(data: newData));
      await saveNewData(newData);
    });

    on<SaveItemEvent>((event, emit) async {
      final newData = await syncWithCloud();

      newData.items.add(event.item);

      newData.updated = false;
      emit(state.copyWith(data: newData));
      await saveNewData(newData);
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
      final newData = await syncWithCloud();

      final itemsInCategory = newData.catItems[event.category];
      if (itemsInCategory != null && event.index >= 0 && event.index < itemsInCategory.length) {
        final itemToRemove = itemsInCategory[event.index];
        newData.items.remove(itemToRemove);
      }

      newData.updated = true;

      emit(state.copyWith(data: newData));
      await saveNewData(newData);
    });

    on<RemoveCheckedItemEvent>((event, emit) async {
      final newData = await syncWithCloud();

      newData.items.removeWhere((item) => item.checked == true);

      newData.updated = false;
      emit(state.copyWith(data: newData));
      await saveNewData(newData);
    });

    on<RemoveAllItemEvent>((event, emit) async {
      final newData = await syncWithCloud();

      newData.items.clear();

      newData.updated = false;

      emit(state.copyWith(data: newData));
      await saveNewData(newData);
    });

    _init();
  }

  void _init() {
    add(LoadListDataEvent());
  }
}