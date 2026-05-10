import 'cart_item.dart';

class Order {
  Order({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.total,
  });

  final String id;
  final DateTime createdAt;
  final List<CartItem> items;
  final double total;
}
