import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repositoryimpl.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepositoryImpl repository;

  List<Product> products = [];
  bool isLoading = false;

  ProductViewModel(this.repository) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      products = await repository.getProducts();
    } catch (e) {
      debugPrint("Erro ao carregar produtos: $e");
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
    notifyListeners();
  }
}
