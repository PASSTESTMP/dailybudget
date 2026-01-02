import 'package:dailybudget/Model/list_data_model.dart';

class ListEvent {}

class LoadListDataEvent extends ListEvent {}

class AddItemEvent extends ListEvent {
  final Item item;
  AddItemEvent(this.item);
}

class RemoveItemEvent extends ListEvent {
  final int index;
  RemoveItemEvent(this.index);
}