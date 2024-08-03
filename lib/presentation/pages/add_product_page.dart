import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  String? _barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
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
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, ingrese un número valido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await BarcodeScanner.scan();
                  setState(() {
                    _barcode = result.rawContent;
                  });
                },
                child: const Text('Escanear Código de Barras'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final product = Product()
                        ..name = _nameController.text
                        ..quantity = int.parse(_quantityController.text)
                        ..price = double.parse(_priceController.text)
                        ..barcode = _barcode;

                      Navigator.pop(context, product);
                    }
                  },
                  child: const Text('Guardar'))
            ],
          ),
        ),
      ),
    );
  }
}
