import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../application/product_service.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_list.dart';
import 'add_product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _showTotalDialog(double total) async {
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text('Total: \$${total.toStringAsFixed(2)}'),
            ));
  }

  Future<void> _handleUpdate(Product product) async {
    await context.read<ProductService>().updateProduct(product);
    setState(() {});
  }

  Future<void> _handleDelete(Product product) async {
    await context.read<ProductService>().deleteProduct(product.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final productService = context.read<ProductService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddProductPage()));

              if (result != null && result is Product) {
                await productService.addProduct(result);
                setState(() {});
              }
            },
          ),
          IconButton(
              icon: const Icon(Icons.payment),
              onPressed: () async {
                final products = await productService.getAllProducts();
                final total = products.fold(
                    0.0, (sum, item) => sum + (item.price * item.quantity));
                _showTotalDialog(total);
                setState(() {});
              }),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await productService.deleteAllProducts();
              setState(() {});
            },
          )
        ],
      ),
      body: FutureBuilder<List<Product>>(
          future: productService.getAllProducts(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Lista vacía'));
            } else {
              return ProductList(
                products: snapshot.data!,
                onUpdate: _handleUpdate,
                onDelete: _handleDelete,
              );
            }
          }),
    );
  }
}
