import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductRemoteDatasource {
  final Dio dio;
  final String baseUrl = 'https://dummyjson.com/products'; // Nova URL

  ProductRemoteDatasource(this.dio);

  Future<List<Product>> fetchProducts() async {
    final response = await dio.get(baseUrl);
    // Acessando a chave 'products' da resposta da DummyJSON
    final List<dynamic> productsJson = response.data['products'];

    return productsJson.map((item) => Product.fromJson(item)).toList();
  }

  Future<Product> addProduct(Product product) async {
    final response = await dio.post('$baseUrl/add', data: product.toJson());
    return Product.fromJson(response.data);
  }

  Future<Product> updateProduct(Product product) async {
    final response = await dio.put(
      '$baseUrl/${product.id}',
      data: product.toJson(),
    );
    return Product.fromJson(response.data);
  }

  Future<void> deleteProduct(int id) async {
    await dio.delete('$baseUrl/$id');
  }
}
