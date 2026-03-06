import '../models/product_model.dart'; // Ajuste o caminho se necessário

class ProductCacheDatasource {
  List<ProductModel>? _cache;
  void save(List<ProductModel> products) {
    _cache = products;
  }

  List<ProductModel>? get() {
    return _cache;
  }
}
