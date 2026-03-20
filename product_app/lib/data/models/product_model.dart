class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description; // Adicionado campo de descrição
  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"],
      price: json["price"].toDouble(),
      image: json["image"],
      description:
          json["description"] ??
          'Nenhuma descriçao disponível', // Fornece uma descrição vazia se o campo estiver ausente
    );
  }
}
