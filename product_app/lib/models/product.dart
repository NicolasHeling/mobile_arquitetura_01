class Product {
  final String id;
  final String name;
  final double price;
  bool favorite;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.favorite = false,
  });
}
