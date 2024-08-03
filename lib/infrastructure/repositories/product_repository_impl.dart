import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/isar_product_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final IsarProductDatasource _datasource;

  ProductRepositoryImpl(this._datasource);

  @override
  Future<void> addProduct(Product product) async {
    await _datasource.addProduct(product);
  }

  @override
  Future<void> deleteAllProducts() async {
    await _datasource.deleteAllProducts();
  }

  @override
  Future<List<Product>> getAllProducts() async {
    return await _datasource.getAllProducts();
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _datasource.updateProduct(product);
  }

  @override
  Future<void> deleteProduct(int productId) async {
    await _datasource.deleteProduct(productId);
  }
}
