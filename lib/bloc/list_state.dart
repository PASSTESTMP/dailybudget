import 'package:dailybudget/Model/list_data_model.dart';

class ListState {
  final ListDataModel data;
  ListState(this.data);
}

class ListUpdatedState extends ListState {
  final ListDataModel newData;
  ListUpdatedState(this.newData) : super(newData);
}