import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/presentation/widgets/custom_text_form_field.dart';

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
  final _barcodeController = TextEditingController();
  String? _barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _nameController,
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
                      controller: _quantityController,
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
                        controller: _priceController,
                        label: 'Precio',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
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
                      controller: _barcodeController,
                      label: 'Código de Barras',
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result =
                                await FlutterBarcodeScanner.scanBarcode(
                                    '#ff6666',
                                    'Cancelar',
                                    false,
                                    ScanMode.BARCODE);
                            setState(() {
                              _barcode = result != '-1' ? result : null;
                              _barcodeController.text = _barcode ?? '';
                            });
                          },
                          label: const Text('Escanear Código de Barras'),
                          icon: const Icon(Icons.barcode_reader),
                        ),
                        ElevatedButton.icon(
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
                          label: const Text('Guardar'),
                          icon: const Icon(Icons.save),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
