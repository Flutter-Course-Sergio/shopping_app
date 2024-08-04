import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import 'custom_text_form_field.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onUpdate;
  final Function(Product) onDelete;

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
        return Card(
          elevation: 5,
          color: Colors.yellow.shade100,
          child: ListTile(
            onTap: () async {
              await _showEditDialog(context, product);
            },
            title: Text(product.name),
            leading: const Icon(Icons.local_grocery_store_rounded,
                color: Colors.grey),
            subtitle: Text(
                'Cantidad ${product.quantity}, Precio: \$${product.price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton.outlined(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    await _showEditDialog(context, product);
                  },
                ),
                IconButton.outlined(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    onDelete(product);
                  },
                ),
              ],
            ),
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
    final TextEditingController barcodeController =
        TextEditingController(text: product.barcode);

    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                controller: nameController,
                label: 'Nombre',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: quantityController,
                label: 'Cantidad',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una cantidad';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, ingrese un número valido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                  controller: priceController,
                  label: 'Precio',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un precio';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, ingrese un número valido';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: barcodeController,
                label: 'Código de Barras',
                enabled: false,
              ),
            ],
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              label: const Text('Cancelar'),
              icon: const Icon(Icons.cancel),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final updatedProduct = Product()
                  ..id = product.id
                  ..name = nameController.text
                  ..quantity = int.parse(quantityController.text)
                  ..price = double.parse(priceController.text)
                  ..barcode = product.barcode;

                Navigator.of(context).pop(updatedProduct);
              },
              label: const Text('Actualizar'),
              icon: const Icon(Icons.save),
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
