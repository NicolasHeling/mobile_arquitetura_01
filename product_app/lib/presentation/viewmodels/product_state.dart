import '../../domain/entities/product.dart';

class ProductState {
  final bool isLoading;
  final List<Product> products;
  final String? error;

  // NOVO: Variável para controlar se a tela deve mostrar apenas os favoritos
  final bool showOnlyFavorites;

  const ProductState({
    this.isLoading = false,
    this.products = const [],
    this.error,
    this.showOnlyFavorites = false, // Por padrão, mostra todos os produtos
  });

  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
    bool? showOnlyFavorites, // Adicionado no copyWith
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error:
          error ??
          this.error, // Alterado sutilmente para não perder o erro ao atualizar o loading
      showOnlyFavorites: showOnlyFavorites ?? this.showOnlyFavorites,
    );
  }
}
