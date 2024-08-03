import '../entities/product.dart';

abstract class ProductRepository {
  Future<void> addProduct(Product product);
  Future<List<Product>> getAllProducts();
  Future<void> deleteAllProducts();
}
