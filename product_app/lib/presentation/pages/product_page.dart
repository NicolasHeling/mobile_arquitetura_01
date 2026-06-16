import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../session/session_controller.dart';
import '../viewmodels/productviewmodel.dart';
import 'login_page.dart';
import 'product_details_page.dart';
import 'product_form_page.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductViewModel>();
    final user = SessionController.instance.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${user?.firstName ?? 'Usuário'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              SessionController.instance.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
          ? Center(
              // Cumpre o tratamento de erro visual caso a API falhe
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    viewModel.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: viewModel.loadProducts,
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await viewModel.loadProducts();
              },
              child: ListView.builder(
                itemCount: viewModel.products.length,
                itemBuilder: (context, index) {
                  final product = viewModel.products[index];
                  // Verifica no ViewModel se este ID é favorito
                  final isFavorite = viewModel.isFavorite(product.id);

                  return ListTile(
                    leading: product.thumbnail.isNotEmpty
                        ? Image.network(
                            product.thumbnail,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image),
                    title: Text(product.title),
                    subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
                    // Cumpre a interface de Marcar/Remover favoritos
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        viewModel.toggleFavorite(product.id);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(productId: product.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
