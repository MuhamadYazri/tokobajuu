import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/formatters.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  final Product product;
  final void Function(BuildContext, Product) onAddToCart;

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
          Text(
            formatCurrency(product.price),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Stock: ${product.stock}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: product.stock == 0
                ? null
                : () => onAddToCart(context, product),
            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
