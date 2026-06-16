import 'package:flutter/material.dart';
import '../../data/repositories/product_repositoryimpl.dart';
import '../../data/models/product_model.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepositoryImpl repository;

  List<Product> products = [];
  List<int> favoriteIds = [];
  bool isLoading = false;
  String? errorMessage;

  // CORREÇÃO AQUI: Adicionado o { loadProducts(); } para buscar os dados ao abrir a tela
  ProductViewModel({required this.repository}) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      products = await repository.getProducts();
    } catch (e) {
      errorMessage = "Erro ao carregar produtos. Verifique sua conexão.";
      debugPrint("Erro: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(int id) {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
    notifyListeners();
  }

  // Função devolvida para a View saber se pinta o coração ou não
  bool isFavorite(int id) {
    return favoriteIds.contains(id);
  }

  Future<void> addProduct(Product product) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final newProduct = await repository.addProduct(product);
      products.add(newProduct);
    } catch (e) {
      errorMessage = "Erro ao adicionar produto: $e";
      debugPrint(errorMessage!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final updatedProduct = await repository.updateProduct(product);
      final index = products.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) {
        products[index] = updatedProduct;
      }
    } catch (e) {
      errorMessage = "Erro ao atualizar produto: $e";
      debugPrint(errorMessage!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await repository.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      favoriteIds.remove(id);
    } catch (e) {
      errorMessage = "Erro ao deletar produto: $e";
      debugPrint(errorMessage!);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
