import 'package:isar/isar.dart';

import '../../domain/entities/product.dart';

class IsarProductDatasource {
  final Isar _isar;

  IsarProductDatasource(this._isar);

  Future<void> addProduct(Product product) async {
    await _isar.writeTxn(() async {
      await _isar.products.put(product);
    });
  }

  Future<List<Product>> getAllProducts() async {
    return await _isar.products.where().findAll();
  }

  Future<void> deleteAllProducts() async {
    await _isar.writeTxn(() async {
      await _isar.products.clear();
    });
  }

  Future<void> updateProduct(Product product) async {
    await _isar.writeTxn(() async {
      await _isar.products.put(product);
    });
  }

  Future<void> deleteProduct(int productId) async {
    await _isar.writeTxn(() async {
      final product = await _isar.products.get(productId);
      if (product != null) {
        await _isar.products.delete(productId);
      }
    });
  }
}
