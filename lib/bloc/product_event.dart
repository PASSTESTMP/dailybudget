import 'package:dailybudget/Model/product_data_model.dart';

class ProductEvent {}

class AddProductEvent extends ProductEvent {
  final String name;
  final int quantity;
  final int target;
  final int threshold;

  AddProductEvent({required this.name, required this.quantity, required this.target, required this.threshold});
}

class UpdateProductEvent extends ProductEvent {
  final int index;
  final Product product;

  UpdateProductEvent({required this.index, required this.product});
}

class RemoveProductEvent extends ProductEvent {
  final String name;

  RemoveProductEvent({required this.name});
}

class SubstractProductEvent extends ProductEvent {
  final String name;
  final int quantity;

  SubstractProductEvent({required this.name, required this.quantity});
}

class LoadProductsEvent extends ProductEvent {}

class SaveProductsEvent extends ProductEvent {
  final Products products;

  SaveProductsEvent({required this.products});
}