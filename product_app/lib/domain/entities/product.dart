class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnail; // Alterado de 'image' para 'thumbnail'
  final String description;
  final String category; // Adicionado para manter a consistência
  final double
  rating; // Adicionado (opcional na API Fake Store, mas útil na DummyJSON)
  final int stock; // Adicionado

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.description,
    required this.category,
    required this.rating,
    required this.stock,
  });
}
