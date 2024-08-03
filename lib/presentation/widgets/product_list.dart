import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onUpdate; // Callback para actualizar un producto
  final Function(Product) onDelete; // Callback para eliminar un producto

  const ProductList({
    super.key,
    required this.products,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, index) {
        final product = products[index];
        return ListTile(
          title: Text(product.name),
          leading: const Icon(Icons.local_grocery_store_rounded),
          subtitle: Text(
              'Cantidad ${product.quantity}, Precio: \$${product.price.toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await _showEditDialog(context, product);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  onDelete(product); // Llama al callback para eliminar
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context, Product product) async {
    final TextEditingController nameController =
        TextEditingController(text: product.name);
    final TextEditingController quantityController =
        TextEditingController(text: product.quantity.toString());
    final TextEditingController priceController =
        TextEditingController(text: product.price.toStringAsFixed(2));

    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final updatedProduct = Product()
                  ..id = product.id
                  ..name = nameController.text
                  ..quantity = int.parse(quantityController.text)
                  ..price = double.parse(priceController.text)
                  ..barcode = product.barcode;

                Navigator.of(context).pop(updatedProduct);
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      onUpdate(result);
    }
  }
}
