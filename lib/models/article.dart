class Article {
  String name;
  double price;
  String descripcion;
  String imagenText;

  Article({
    required this.name,
    required this.price,
    required this.descripcion,
    required this.imagenText,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      name: json['name'] ?? '',
      price: json['price'] != null ? double.parse(json['price'].toString()) : 0.0,
      descripcion: json['description'] ?? '',
      imagenText: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": descripcion,
      "price": price,
      "image": imagenText,
    };
  }
}