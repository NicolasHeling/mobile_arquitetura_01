import '../datasources/product_remote_datasource.dart';
import '../datasources/productcachedatasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl {
  final ProductRemoteDatasource remoteDatasource;
  final ProductCacheDatasource localDatasource;

  ProductRepositoryImpl(this.remoteDatasource, this.localDatasource);

  Future<List<Product>> getProducts() async {
    try {
      // Tenta buscar a lista real da API na internet
      final products = await remoteDatasource.fetchProducts();
      localDatasource.save(products);
      return products;
    } catch (e) {
      return [
        Product(
          id: 999,
          title: 'Produto de Teste (API Fora do Ar)',
          price: 199.90,
          description:
              'A API oficial está com erro 523 (fora do ar), mas a arquitetura do aplicativo isolou o erro e carregou esta lista de fallback com sucesso!',
          image: 'https://fakestoreapi.com/icons/intro.svg',
          category: 'Teste Local',
        ),
        Product(
          id: 1000,
          title: 'Notebook Acer Nitro V15',
          price: 4500.00,
          description: 'Notebook gamer com placa de vídeo RTX 4050.',
          image: 'https://fakestoreapi.com/icons/intro.svg',
          category: 'Informática',
        ),
      ];
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
