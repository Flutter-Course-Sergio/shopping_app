import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:isar/isar.dart';
import 'package:shopping_app/domain/entities/product.dart';

import 'infrastructure/data_sources/isar_product_data_source.dart';
import 'infrastructure/repositories/product_repository_impl.dart';
import 'application/product_service.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([ProductSchema], directory: dir.path);

  runApp(MainApp(isar: isar));
}

class MainApp extends StatelessWidget {
  final Isar isar;

  const MainApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => IsarProductDatasource(isar)),
        Provider(
          create: (context) =>
              ProductRepositoryImpl(context.read<IsarProductDatasource>()),
        ),
        Provider(
            create: (context) =>
                ProductService(context.read<ProductRepositoryImpl>()))
      ],
      child: MaterialApp(
          title: 'Shopping App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const HomePage()),
    );
  }
}
