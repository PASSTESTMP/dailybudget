/*
  Future<void> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getString('products') ?? '[]';
    final List<dynamic> productList = jsonDecode(productsJson);
    setState(() {
      products = productList.map((e) => Product.fromJson(e)).toList();
    });
    _refreshItems();
  }

Future<void> _refreshItems() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final settings = Provider.of<SettingsModel>(context, listen: false);

      bool useCloud = settings.useCloud;
      if (useCloud && !isPC()) {
        await settings.cloudProvider.fetchData('defaultLists', settings.email).then((data) {
          setState(() {
            if (data.isNotEmpty) {
              if (data[0]["Error"]!= null) {
                products = [];
                settings.infoMessage = "Potwierdź email zanim się zalogujesz";
              } else if (data[0]['products'] != null) {
                final List<dynamic> productList = jsonDecode(data[0]['products']);
                products = productList.map((e) => Product.fromJson(e)).toList();
              } else {
                products = [];
              }
            } else {
              products = [];
            }
          });
        });
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('products', json.encode(products));
    });
  }

   Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = jsonEncode(products.map((e) => e.toJson()).toList());
    await prefs.setString('products', productsJson);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final settings = Provider.of<SettingsModel>(context, listen: false);

      bool useCloud = settings.useCloud;
      if (useCloud && !isPC()) {
        await settings.cloudProvider.uploadData('defaultLists', {
          'id': settings.email,
          'products': productsJson,
        });
      }
    });

    _loadProducts();
  }

*/

import 'package:dailybudget/Model/product_data_model.dart';
import 'package:dailybudget/Model/settings_data_model.dart';
import 'package:dailybudget/bloc/product_event.dart';
import 'package:dailybudget/bloc/product_state.dart';
import 'package:dailybudget/features/local_storage_service_prod.dart';
import 'package:dailybudget/features/secure_log_service.dart';
import 'package:dailybudget/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final LocalStorageServiceProd _storageService;
  final secureLog = SecureLogService();
  
  ProductBloc(this._storageService) : super(ProductState.initial()) {
    
    Future<Products> syncWithCloud() async {
      Products newData =  Products.initial();

      final settings = SettingsDataModel();
      await settings.loadSettings();

      bool useCloud = state.settings.useCloud;
      if (useCloud && !isPC()) {
        await settings.cloudProvider.fetchData('shoppingLists', settings.email).then((data) {
          if (data.isNotEmpty) {
            if (data[0]["Error"]!= null) {
              settings.infoMessage = "Potwierdź email zanim się zalogujesz";
            } else {
              newData = Products.fromJson(data[0]['products']);
            }
          }
        });

        await _storageService.saveToPreferences(newData);
      } else {
        newData = await _storageService.getFromPreferences();
      }
      return newData;
    }

    on<LoadProductsEvent>((event, emit) async {
      final newData = await syncWithCloud();
      emit(ProductStateLoaded(products: newData, settings: state.settings));
    });

    on<AddProductEvent>((event, emit) async {
      final newData = await syncWithCloud();

      newData.products.add(Product(name: event.name, actualQuantity: 0, threshold: 0, targetQuantity: 0));

      await _storageService.saveToPreferences(newData);
      emit(ProductStateLoaded(products: newData, settings: state.settings));
    });

    on<UpdateProductEvent>((event, emit) async {
      final newData = await syncWithCloud();

      if (event.index >= 0 && event.index < newData.products.length) {
        newData.products[event.index] = event.product;
      }

      await _storageService.saveToPreferences(newData);
      emit(ProductStateLoaded(products: newData, settings: state.settings));
    });

    on<SaveProductsEvent>((event, emit) async {
      final newData = event.products;

      await _storageService.saveToPreferences(newData);
      emit(ProductStateLoaded(products: newData, settings: state.settings));
    });
  }
}