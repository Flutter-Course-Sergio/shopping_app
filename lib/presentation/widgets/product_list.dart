import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text(
                'Cantidad ${product.quantity}, Precio: \$${product.price.toStringAsFixed(2)}'),
          );
        });
  }
}
