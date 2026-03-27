import '../models/product_model.dart';

class ProductCacheDatasource {
  List<Product>? _cache;

  void save(List<Product> products) {
    _cache = products;
  }

  List<Product>? get() {
    return _cache;
  }
}
