import 'package:dailybudget/Model/product_data_model.dart';
import 'package:dailybudget/Model/settings_data_model.dart';

class ProductState {
  final Products data;
  final SettingsDataModel settings;

  const ProductState({
    required this.data,
    required this.settings,
  });

  static ProductState initial() => ProductState(
    data: Products.initial(),
    settings: SettingsDataModel.initial(),
  );

  ProductState copyWith({
    Products? data,
    SettingsDataModel? settings,
  }) {
    return ProductState(
      data: data ?? this.data,
      settings: settings ?? this.settings,
    );
  }
}

class ProductStateLoaded extends ProductState {
  final Products products;

  const ProductStateLoaded({
    required this.products,
    required super.settings,
  }) : super(data: products);
}