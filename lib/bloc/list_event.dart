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

class SaveItemEvent extends ListEvent {
  final String item;
  SaveItemEvent(this.item);
}

class UpdateLogByEmailEvent  extends ListEvent{
  final bool logByEmail;
  UpdateLogByEmailEvent(this.logByEmail);
}

class UpdateEmailEvent extends ListEvent {
  final String email;
  UpdateEmailEvent(this.email);
}

class UpdatePasswordEvent extends ListEvent {
  final String password;
  UpdatePasswordEvent(this.password);
}

class UpdateCloudProviderEvent extends ListEvent {
  final String provider;
  UpdateCloudProviderEvent(this.provider);
}