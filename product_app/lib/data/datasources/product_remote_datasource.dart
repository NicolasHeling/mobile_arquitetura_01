import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductRemoteDatasource {
  final Dio dio;
  final String baseUrl = 'https://dummyjson.com/products';

  ProductRemoteDatasource(this.dio);

  Future<List<Product>> fetchProducts() async {
    final response = await dio.get(baseUrl);
    final List<dynamic> productsJson = response.data['products'];
    return productsJson.map((item) => Product.fromJson(item)).toList();
  }

  // NOVO MÉTODO: Busca detalhes via /products/{id}
  Future<Product> fetchProductById(int id) async {
    final response = await dio.get('$baseUrl/$id');
    if (response.statusCode == 200) {
      return Product.fromJson(response.data);
    } else {
      throw Exception('Erro ao carregar detalhes do produto');
    }
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
