import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductRemoteDatasource {
  final Dio dio;
  final String baseUrl = 'https://fakestoreapi.com/products';

  ProductRemoteDatasource(this.dio);

  Future<List<Product>> fetchProducts() async {
    final response = await dio.get(baseUrl);
    return (response.data as List)
        .map((item) => Product.fromJson(item))
        .toList();
  }

  Future<Product> addProduct(Product product) async {
    final response = await dio.post(baseUrl, data: product.toJson());
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
