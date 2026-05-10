import 'package:flutter/material.dart';

void main() {
  runApp(const StoreApp());
}

class StoreApp extends StatefulWidget {
  const StoreApp({super.key});

  @override
  State<StoreApp> createState() => _StoreAppState();
}

class _StoreAppState extends State<StoreApp> {
  final List<Product> _products = [
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

  final List<CartItem> _cart = [];
  final List<Order> _orders = [];
  int _navIndex = 0;

  void _addToCart(Product product) {
    setState(() {
      final existing = _cart.where((item) => item.product.id == product.id);
      if (existing.isNotEmpty) {
        existing.first.quantity += 1;
      } else {
        _cart.add(CartItem(product: product, quantity: 1));
      }
    });
  }

  void _updateQuantity(Product product, int quantity) {
    setState(() {
      final index = _cart.indexWhere((item) => item.product.id == product.id);
      if (index == -1) {
        return;
      }
      if (quantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].quantity = quantity;
      }
    });
  }

  void _clearCart() {
    setState(_cart.clear);
  }

  void _placeOrder() {
    if (_cart.isEmpty) {
      return;
    }
    setState(() {
      _orders.add(
        Order(
          id: 'o${_orders.length + 1}',
          createdAt: DateTime.now(),
          items: List<CartItem>.from(_cart
              .map((item) => CartItem(product: item.product, quantity: item.quantity))),
          total: _cartTotal,
        ),
      );
      _cart.clear();
    });
  }

  double get _cartTotal {
    return _cart.fold(0, (sum, item) => sum + item.product.price * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Toko Baju',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: StoreShell(
        navIndex: _navIndex,
        products: _products,
        cart: _cart,
        orders: _orders,
        cartTotal: _cartTotal,
        onNavChange: (index) => setState(() => _navIndex = index),
        onAddToCart: _addToCart,
        onUpdateQuantity: _updateQuantity,
        onClearCart: _clearCart,
        onPlaceOrder: _placeOrder,
      ),
    );
  }
}

class StoreShell extends StatelessWidget {
  const StoreShell({
    super.key,
    required this.navIndex,
    required this.products,
    required this.cart,
    required this.orders,
    required this.cartTotal,
    required this.onNavChange,
    required this.onAddToCart,
    required this.onUpdateQuantity,
    required this.onClearCart,
    required this.onPlaceOrder,
  });

  final int navIndex;
  final List<Product> products;
  final List<CartItem> cart;
  final List<Order> orders;
  final double cartTotal;
  final ValueChanged<int> onNavChange;
  final ValueChanged<Product> onAddToCart;
  final void Function(Product, int) onUpdateQuantity;
  final VoidCallback onClearCart;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(products: products, onAddToCart: onAddToCart),
      CartScreen(
        cart: cart,
        total: cartTotal,
        onUpdateQuantity: onUpdateQuantity,
        onClearCart: onClearCart,
        onPlaceOrder: onPlaceOrder,
      ),
      ProfileScreen(orders: orders),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Baju'),
      ),
      body: pages[navIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        onTap: onNavChange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.products, required this.onAddToCart});

  final List<Product> products;
  final ValueChanged<Product> onAddToCart;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'New Arrivals',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Stock UI only. Replace later with your own design.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        ...products.map((product) => ProductCard(
              product: product,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(
                    product: product,
                    onAddToCart: onAddToCart,
                  ),
                ),
              ),
              onAddToCart: () => onAddToCart(product),
            )),
      ],
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.checkroom, size: 36, color: Colors.indigo),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(product.category, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(formatCurrency(product.price),
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text('Stock: ${product.stock}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: product.stock == 0 ? null : onAddToCart,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  final Product product;
  final ValueChanged<Product> onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.checkroom, size: 96, color: Colors.indigo),
          ),
          const SizedBox(height: 16),
          Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(product.category, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Text(formatCurrency(product.price),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Stock: ${product.stock}',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: product.stock == 0 ? null : () => onAddToCart(product),
            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    required this.cart,
    required this.total,
    required this.onUpdateQuantity,
    required this.onClearCart,
    required this.onPlaceOrder,
  });

  final List<CartItem> cart;
  final double total;
  final void Function(Product, int) onUpdateQuantity;
  final VoidCallback onClearCart;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) {
      return Center(
        child: Text(
          'Your cart is empty',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...cart.map((item) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.checkroom, color: Colors.indigo),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.name,
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 4),
                          Text(formatCurrency(item.product.price),
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => onUpdateQuantity(
                            item.product,
                            item.quantity - 1,
                          ),
                          icon: const Icon(Icons.remove),
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          onPressed: () => onUpdateQuantity(
                            item.product,
                            item.quantity + 1,
                          ),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 12),
        Text('Total: ${formatCurrency(total)}',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CheckoutSummaryScreen(
                cart: cart,
                total: total,
                onClearCart: onClearCart,
                onPlaceOrder: onPlaceOrder,
              ),
            ),
          ),
          child: const Text('Checkout Summary'),
        ),
      ],
    );
  }
}

class CheckoutSummaryScreen extends StatelessWidget {
  const CheckoutSummaryScreen({
    super.key,
    required this.cart,
    required this.total,
    required this.onClearCart,
    required this.onPlaceOrder,
  });

  final List<CartItem> cart;
  final double total;
  final VoidCallback onClearCart;
  final VoidCallback onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    final shipping = cart.isEmpty ? 0.0 : 18000.0;
    final grandTotal = total + shipping;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout Summary')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Items', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...cart.map((item) => ListTile(
                title: Text(item.product.name),
                subtitle: Text('Qty ${item.quantity}'),
                trailing: Text(formatCurrency(item.product.price * item.quantity)),
              )),
          const Divider(height: 32),
          SummaryRow(label: 'Subtotal', value: formatCurrency(total)),
          SummaryRow(label: 'Shipping', value: formatCurrency(shipping)),
          SummaryRow(label: 'Total', value: formatCurrency(grandTotal), bold: true),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: cart.isEmpty
                ? null
                : () {
                    onPlaceOrder();
                    onClearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order placed successfully.')),
                    );
                    Navigator.of(context).pop();
                  },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  const SummaryRow({super.key, required this.label, required this.value, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.orders});

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
        const SizedBox(height: 12),
        Text('Guest User', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text('guest@email.com', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.receipt_long),
          title: const Text('Order History'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OrderHistoryScreen(orders: orders),
            ),
          ),
        ),
      ],
    );
  }
}

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key, required this.orders});

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: orders.isEmpty
          ? Center(
              child: Text('No orders yet',
                  style: Theme.of(context).textTheme.titleMedium),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: orders
                  .map((order) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text('Order ${order.id}'),
                          subtitle: Text(
                            '${order.items.length} items - ${order.createdAt.toLocal().toString().split(".").first}',
                          ),
                          trailing: Text(formatCurrency(order.total)),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}

class Product {
  Product({
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

class CartItem {
  CartItem({required this.product, required this.quantity});

  final Product product;
  int quantity;
}

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

String formatCurrency(double value) {
  return 'Rp ${value.toStringAsFixed(0)}';
}
