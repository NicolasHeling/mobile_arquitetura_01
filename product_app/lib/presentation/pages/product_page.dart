import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/productviewmodel.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuta o ViewModel para reagir a mudanças de estado
    final viewModel = context.watch<ProductViewModel>();
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          // Botão para o Desafio Opcional: Filtrar favoritos
          IconButton(
            icon: Icon(
              state.showOnlyFavorites
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
            onPressed: () =>
                viewModel.toggleFilter(), // Chama a lógica de filtro
            tooltip: 'Mostrar apenas favoritos',
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text('Erro: ${state.error}'));
          }

          // Mudança crucial: Usar viewModel.visibleProducts em vez de state.products
          // para que o filtro e a lista funcionem juntos
          final productsToShow = viewModel.visibleProducts;

          if (productsToShow.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          return ListView.builder(
            itemCount: productsToShow.length,
            itemBuilder: (context, index) {
              final product = productsToShow[index];

              return ListTile(
                // === A IMAGEM FOI ADICIONADA AQUI ===
                leading: Image.network(
                  product.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  // Se a URL da imagem falhar, mostra um ícone padrão de erro
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 50),
                ),
                title: Text(product.title),
                subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
                // Botão de Favorito (Funcionalidade Obrigatória)
                trailing: IconButton(
                  icon: Icon(
                    // Verifica se o ID está no Set de favoritos
                    viewModel.isFavorite(product.id)
                        ? Icons.star
                        : Icons.star_border,
                    color: viewModel.isFavorite(product.id)
                        ? Colors.orange
                        : null,
                  ),
                  onPressed: () {
                    // Alterna o estado do favorito ao clicar
                    viewModel.toggleFavorite(product.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
