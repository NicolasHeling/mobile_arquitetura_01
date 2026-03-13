import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  // Lista inicial de produtos
  final List<Product> _products = [
    Product(id: '1', name: 'Notebook Acer Nitro V15', price: 4500.00),
    Product(id: '2', name: 'SSD Patriot M.2 P300 256GB', price: 150.00),
    Product(id: '3', name: 'Mouse Gamer', price: 120.00),
    Product(id: '4', name: 'Mesa Digitalizadora', price: 250.00),
    Product(id: '5', name: 'Monitor 144hz', price: 900.00),
  ];

  bool _showOnlyFavorites = false;

  // Retorna a lista filtrada ou completa dependendo do estado do filtro
  List<Product> get products {
    if (_showOnlyFavorites) {
      return _products.where((prod) => prod.favorite).toList();
    }
    return _products;
  }

  // Desafio opcional: Contador de favoritos
  int get favoriteCount => _products.where((prod) => prod.favorite).length;

  bool get showOnlyFavorites => _showOnlyFavorites;

  // Altera o status de favorito de um produto específico
  void toggleFavorite(String id) {
    final index = _products.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _products[index].favorite = !_products[index].favorite;
      notifyListeners(); // Notifica a interface para se reconstruir
    }
  }

  // Desafio opcional: Alterna o filtro para mostrar apenas favoritos
  void toggleFilter() {
    _showOnlyFavorites = !_showOnlyFavorites;
    notifyListeners();
  }
}
