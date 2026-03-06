import 'package:dio/dio.dart'; // Ou o seu cliente HTTP personalizado da camada core
import '../models/product_model.dart';

class ProductRemoteDatasource {
  final Dio client; // Ajustado para Dio conforme o seu main.dart

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    // Correção: URL limpa e sem espaços
    final response = await client.get("https://fakestoreapi.com/products");

    final List data = response.data;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }
}
