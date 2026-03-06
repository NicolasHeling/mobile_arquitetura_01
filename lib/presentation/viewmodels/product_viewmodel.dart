import 'package:flutter/foundation.dart';
import '../../domain/product_repository.dart';
import 'product_state.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository repository;

  // O ValueNotifier continua a ser usado para notificar a UI sobre mudanças no ProductState
  final ValueNotifier<ProductState> state = ValueNotifier(const ProductState());

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    // Inicia o carregamento
    state.value = state.value.copyWith(isLoading: true, error: null);

    try {
      // Correção: O método correto no repositório é getAll() conforme o contrato do domínio
      final products = await repository.getProducts();

      state.value = state.value.copyWith(isLoading: false, products: products);
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
    }

    // Notifica ouvintes se necessário (importante para integração com Provider)
    notifyListeners();
  }
}
