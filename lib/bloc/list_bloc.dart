import 'package:dailybudget/Model/list_data_model.dart';
import 'package:dailybudget/bloc/list_event.dart';
import 'package:dailybudget/bloc/list_state.dart';
import 'package:dailybudget/features/local_storage_service_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final LocalStorageServiceList _storageService;

  ListBloc(this._storageService) : super(ListState(ListDataModel())){


    on<LoadListDataEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();
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


    _init();
  }

  void _init() {
    add(LoadListDataEvent());
  }
}