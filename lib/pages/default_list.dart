
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DefaultListPage extends StatefulWidget {
  const DefaultListPage({super.key});

  @override
  _DefaultListPageState createState() => _DefaultListPageState();
}

class _DefaultListPageState extends State<DefaultListPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          Color backgroundColor;

          if (product.actualQuantity > product.threshold) {
            backgroundColor = Colors.green;
          } else if (product.actualQuantity == product.threshold) {
            backgroundColor = Colors.yellow;
          } else {
            backgroundColor = Colors.red;
          }

          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onLongPress: () {
                    showAddProductDialog(context, products, product, _saveProducts);
                  },
                  child: Text(
                    product.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          products[index] = Product(
                            name: product.name,
                            actualQuantity: product.actualQuantity + 1,
                            targetQuantity: product.targetQuantity,
                            threshold: product.threshold,
                          );
                        });
                        _saveProducts();
                      },
                    ),
                    Text(
                      '${product.actualQuantity} / ${product.targetQuantity}',
                      style: TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (product.actualQuantity > 0) {
                          setState(() {
                            products[index] = Product(
                              name: product.name,
                              actualQuantity: product.actualQuantity - 1,
                              targetQuantity: product.targetQuantity,
                              threshold: product.threshold,
                            );
                          });
                          _saveProducts();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddProductDialog(context, products, null, _saveProducts);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Product {
  final String name;
  final int actualQuantity;
  final int targetQuantity;
  final int threshold;

  Product({
    required this.name,
    required this.actualQuantity,
    required this.targetQuantity,
    required this.threshold,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      actualQuantity: json['actualQuantity'],
      targetQuantity: json['targetQuantity'],
      threshold: json['threshold'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'actualQuantity': actualQuantity,
      'targetQuantity': targetQuantity,
      'threshold': threshold,
    };
  }
}

void showAddProductDialog(BuildContext context, List<Product> products, Product? product, Function saveProducts) {
  final nameController = TextEditingController();
  final actualQuantityController = TextEditingController();
  final targetQuantityController = TextEditingController();
  final thresholdController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController..text = product?.name ?? '',
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: actualQuantityController..text = product?.actualQuantity.toString() ?? '',
              decoration: InputDecoration(labelText: 'Actual Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: targetQuantityController..text = product?.targetQuantity.toString() ?? '',
              decoration: InputDecoration(labelText: 'Target Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: thresholdController..text = product?.threshold.toString() ?? '',
              decoration: InputDecoration(labelText: 'Threshold Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          if (product != null)
            TextButton(
              onPressed: () {
                products.remove(product);
                saveProducts();
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final actualQuantity = int.tryParse(actualQuantityController.text) ?? 0;
              final targetQuantity = int.tryParse(targetQuantityController.text) ?? 0;
              final threshold = int.tryParse(thresholdController.text) ?? 0;
              if (product != null) {
                products.remove(product);
              }
              if (name.isNotEmpty && targetQuantity > 0) {
                products.add(Product(
                  name: name,
                  actualQuantity: actualQuantity,
                  targetQuantity: targetQuantity,
                  threshold: threshold,
                ));
                saveProducts();
                Navigator.of(context).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}