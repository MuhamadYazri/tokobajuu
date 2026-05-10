import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../utils/formatters.dart';
import '../widgets/summary_row.dart';

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
