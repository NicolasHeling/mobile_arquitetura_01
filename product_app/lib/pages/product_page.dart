import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta as mudanças do provider
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          // Desafio opcional: Contador no topo
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Favoritos: ${provider.favoriteCount}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Desafio opcional: Botão de filtro
          IconButton(
            icon: Icon(
              provider.showOnlyFavorites
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => provider.toggleFilter(),
            tooltip: 'Filtrar favoritos',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: provider.products.length,
        itemBuilder: (context, index) {
          final product = provider.products[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            // Desafio opcional: Destaque visual
            color: product.favorite ? Colors.amber.shade50 : Colors.white,
            child: ListTile(
              title: Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
              trailing: IconButton(
                icon: Icon(
                  product.favorite ? Icons.star : Icons.star_border,
                  color: product.favorite ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  // Aciona a mudança de estado
                  provider.toggleFavorite(product.id);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
