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
    // Recupera os dados do utilizador logado na sessão
    final user = SessionController.instance.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${user?.firstName ?? 'Usuário'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              // Executa o logout e volta para a tela de login
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
          : RefreshIndicator(
              // CORREÇÃO AQUI: mudou de onPressed para onRefresh e adicionou async
              onRefresh: () async {
                await viewModel.loadProducts();
              },
              child: ListView.builder(
                itemCount: viewModel.products.length,
                itemBuilder: (context, index) {
                  final product = viewModel.products[index];
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
