import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/models/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  // Agora recebe apenas o ID, conforme a exigência do professor
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<Product> _productFuture;
  final ProductRemoteDatasource _datasource = ProductRemoteDatasource(Dio());

  @override
  void initState() {
    super.initState();
    // Faz uma nova chamada à API para buscar os detalhes pelo ID
    _productFuture = _datasource.fetchProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Produto')),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          // Mostra o loading enquanto espera a resposta da API
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Produto não encontrado'));
          }

          final product = snapshot.data!;
          // Renderiza a tela após carregar com sucesso
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.network(product.thumbnail, height: 200)),
                const SizedBox(height: 20),
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Preço: R\$ ${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, color: Colors.green),
                ),
                const SizedBox(height: 10),
                Text('Categoria: ${product.category}'),
                const SizedBox(height: 10),
                Text('Avaliação: ${product.rating} ⭐'),
                const SizedBox(height: 20),
                const Text(
                  'Descrição:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(product.description),
              ],
            ),
          );
        },
      ),
    );
  }
}
