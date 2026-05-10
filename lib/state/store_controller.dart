import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';

class StoreController extends ChangeNotifier {
  StoreController() {
    _products = const [
      Product(
        id: 'p1',
        name: 'Classic White Tee',
        category: 'T-Shirts',
        price: 99000,
        stock: 18,
        description: 'Soft cotton tee for everyday wear.',
      ),
      Product(
        id: 'p2',
        name: 'Denim Jacket',
        category: 'Outerwear',
        price: 249000,
        stock: 6,
        description: 'Vintage fit denim jacket with clean seams.',
      ),
      Product(
        id: 'p3',
        name: 'Slim Chino Pants',
        category: 'Pants',
        price: 189000,
        stock: 10,
        description: 'Stretch chinos for smart casual styling.',
      ),
      Product(
        id: 'p4',
        name: 'Oversize Hoodie',
        category: 'Hoodies',
        price: 199000,
        stock: 8,
        description: 'Warm fleece hoodie with relaxed fit.',
      ),
      Product(
        id: 'p5',
        name: 'Linen Shirt',
        category: 'Shirts',
        price: 159000,
        stock: 12,
        description: 'Breathable linen shirt for hot days.',
      ),
      Product(
        id: 'p6',
        name: 'Pleated Skirt',
        category: 'Skirts',
        price: 129000,
        stock: 9,
        description: 'Flowy skirt with soft pleats.',
      ),
    ];
  }

  late final List<Product> _products;
  final List<CartItem> _cart = [];
  final List<Order> _orders = [];
  int _navIndex = 0;
  bool _isLoggedIn = false;
  String _userEmail = '';

  List<Product> get products => List.unmodifiable(_products);
  List<CartItem> get cart => List.unmodifiable(_cart);
  List<Order> get orders => List.unmodifiable(_orders);
  int get navIndex => _navIndex;
  bool get isLoggedIn => _isLoggedIn;
  String get userEmail => _userEmail;

  double get cartTotal {
    return _cart.fold(0, (sum, item) => sum + item.product.price * item.quantity);
  }

  void setNavIndex(int index) {
    if (_navIndex == index) {
      return;
    }
    _navIndex = index;
    notifyListeners();
  }

  void login(String email) {
    _isLoggedIn = true;
    _userEmail = email;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userEmail = '';
    _orders.clear();
    notifyListeners();
  }

  void addToCart(Product product) {
    final existing = _cart.where((item) => item.product.id == product.id);
    if (existing.isNotEmpty) {
      existing.first.quantity += 1;
    } else {
      _cart.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      return;
    }
    if (quantity <= 0) {
      _cart.removeAt(index);
    } else {
      _cart[index].quantity = quantity;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void placeOrder() {
    if (_cart.isEmpty) {
      return;
    }
    final items = _cart
        .map((item) => CartItem(product: item.product, quantity: item.quantity))
        .toList();
    _orders.add(
      Order(
        id: 'o${_orders.length + 1}',
        createdAt: DateTime.now(),
        items: items,
        total: cartTotal,
      ),
    );
    _cart.clear();
    notifyListeners();
  }
}
