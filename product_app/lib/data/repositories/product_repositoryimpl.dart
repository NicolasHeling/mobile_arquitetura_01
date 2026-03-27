import '../datasources/product_remote_datasource.dart';
import '../datasources/productcachedatasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl {
  final ProductRemoteDatasource remoteDatasource;
  final ProductCacheDatasource localDatasource;

  ProductRepositoryImpl(this.remoteDatasource, this.localDatasource);

  Future<List<Product>> getProducts() async {
    try {
      final products = await remoteDatasource.fetchProducts();
      localDatasource.save(products);
      return products;
    } catch (e) {
      final cached = localDatasource.get();
      if (cached != null) return cached;
      throw Exception('Erro ao carregar produtos');
    }
  }

  Future<Product> addProduct(Product product) async {
    return await remoteDatasource.addProduct(product);
  }

  Future<Product> updateProduct(Product product) async {
    return await remoteDatasource.updateProduct(product);
  }

  Future<void> deleteProduct(int id) async {
    await remoteDatasource.deleteProduct(id);
  }
}
