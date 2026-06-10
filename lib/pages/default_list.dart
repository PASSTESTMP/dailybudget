import 'package:dailybudget/bloc/product_bloc.dart';
import 'package:dailybudget/bloc/product_event.dart';
import 'package:dailybudget/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Model/product_data_model.dart';

class DefaultListPage extends StatefulWidget {
  const DefaultListPage({super.key});

  @override
  State<DefaultListPage> createState() => _DefaultListPageState();
}

class _DefaultListPageState extends State<DefaultListPage> {
  Products products = Products(products: []);

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductStateLoaded) {
            products = state.products;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                Color backgroundColor;
                Color textColor = Colors.white;

                if (product.quantity > product.threshold) {
                  backgroundColor = Colors.green;
                  textColor = Colors.white;
                } else if (product.quantity == product.threshold) {
                  backgroundColor = Colors.yellow;
                  textColor = Colors.black;
                } else {
                  backgroundColor = Colors.red;
                  textColor = Colors.white;
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
                      showAddProductDialog(context, products, product);
                    },
                    child: Text(
                      product.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ),
                  Row(children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          products[index] = Product(
                            name: product.name,
                            quantity: product.quantity + 1,
                            target: product.target,
                            threshold: product.threshold,
                          );
                        });
                      context.read<ProductBloc>().add(SaveProductsEvent(products: products));
                    },
                  ),
                  Text(
                    '${product.quantity} / ${product.target}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (product.quantity > 0) {
                        setState(() {
                          products[index] = Product(
                            name: product.name,
                            quantity: product.quantity - 1,
                            target: product.target,
                            threshold: product.threshold,
                          );
                        });
                        context.read<ProductBloc>().add(SaveProductsEvent(products: products));
                      }
                    },
                  ),
                ],
                  ),
                ],
              ),
            );
          },
        );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'default_list_fab',
        onPressed: () {
          showAddProductDialog(context, products, null);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}



void showAddProductDialog(BuildContext context, Products products, Product? product) {
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
              controller: actualQuantityController..text = product?.quantity.toString() ?? '',
              decoration: InputDecoration(labelText: 'Actual Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: targetQuantityController..text = product?.target.toString() ?? '',
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
                context.read<ProductBloc>().add(SaveProductsEvent(products: products));
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
                  quantity: actualQuantity,
                  target: targetQuantity,
                  threshold: threshold,
                ));
                context.read<ProductBloc>().add(SaveProductsEvent(products: products));
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