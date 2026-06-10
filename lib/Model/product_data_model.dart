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

class Products {
  List<Product> products;

  Products({required this.products});

  factory Products.fromJson(List<dynamic> json) {
    return Products(
      products: json.map((item) => Product.fromJson(item)).toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return products.map((product) => product.toJson()).toList();
  }

  void operator []=(int index, Product value) {
    products[index] = value;
  }

  Product operator [](int index) {
    return products[index];
  }

  int get length => products.length;

  static Products initial() {
    return Products(products: []);
  }

  void remove(Product product) {
    products.remove(product);
  }

  void add(Product product) {
    products.add(product);
  }
}