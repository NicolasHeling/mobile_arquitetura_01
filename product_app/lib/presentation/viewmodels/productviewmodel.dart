import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repositoryimpl.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepositoryImpl repository;

  List<Product> products = [];
  bool isLoading = false;
  String?
  errorMessage; // Adicionado para cumprir "Tratamento de erro nas requisições"

  // Adicionado para cumprir "Controle de favoritos"
  List<int> favoriteIds = [];

  ProductViewModel(this.repository) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading = true;
    errorMessage = null; // Reseta o erro
    notifyListeners();

    try {
      products = await repository.getProducts();
    } catch (e) {
      errorMessage = "Erro ao carregar produtos: $e";
      debugPrint(errorMessage);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final newProduct = await repository.addProduct(product);
    products.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final updatedProduct = await repository.updateProduct(product);
    final index = products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      products[index] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    await repository.deleteProduct(id);
    products.removeWhere((p) => p.id == id);
    favoriteIds.remove(id); // Remove dos favoritos se for deletado
    notifyListeners();
  }

  // Métodos para cumprir "Marcar/Remover produto dos favoritos" e "Atualização automática"
  void toggleFavorite(int id) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
    notifyListeners(); // Avisa a interface para reconstruir
  }

  bool isFavorite(int id) {
    return favoriteIds.contains(id);
  }
}
