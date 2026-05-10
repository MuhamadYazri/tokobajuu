class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.description,
  });

  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String description;
}
