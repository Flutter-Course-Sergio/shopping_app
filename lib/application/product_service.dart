import '../domain/entities/product.dart';
import '../domain/repositories/product_repository.dart';

class ProductService {
  final ProductRepository _repository;

  ProductService(this._repository);

  Future<void> addProduct(Product product) async {
    await _repository.addProduct(product);
  }

  Future<List<Product>> getAllProducts() async {
    return await _repository.getAllProducts();
  }

  Future<void> deleteAllProducts() async {
    await _repository.deleteAllProducts();
  }
}
