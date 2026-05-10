import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../utils/formatters.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    required this.cart,
    required this.total,
    required this.onUpdateQuantity,
    required this.onClearCart,
    required this.onCheckout,
  });

  final List<CartItem> cart;
  final double total;
  final void Function(Product, int) onUpdateQuantity;
  final VoidCallback onClearCart;
  final void Function(BuildContext) onCheckout;

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
          onPressed: () => onCheckout(context),
          child: const Text('Checkout Summary'),
        ),
      ],
    );
  }
}
