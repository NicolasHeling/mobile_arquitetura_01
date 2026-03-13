import 'package:flutter/foundation.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import 'product_state.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository repository;

  ProductState _state = const ProductState();
  ProductState get state => _state;

  final Set<int> _favoriteIds = {};

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final products = await repository.getProducts();
      _state = _state.copyWith(isLoading: false, products: products);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(isLoading: false, error: e.toString());
      notifyListeners();
    }
  }

  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId);
  }

  void toggleFavorite(int productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  void toggleFilter() {
    _state = _state.copyWith(showOnlyFavorites: !_state.showOnlyFavorites);
    notifyListeners();
  }

  List<Product> get visibleProducts {
    if (_state.showOnlyFavorites) {
      return _state.products.where((p) => _favoriteIds.contains(p.id)).toList();
    }
    return _state.products;
  }

  int get favoriteCount => _favoriteIds.length;
}
