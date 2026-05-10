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

  static const List<String> _itemImages = [
    'https://images.unsplash.com/photo-1520975954732-35dd222996f1?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=900&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) {
      return _EmptyCart(onContinue: () {});
    }

    final itemCount = cart.fold(0, (sum, item) => sum + item.quantity);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      children: [
        Text('Your Cart', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 4),
        Text(
          '$itemCount items',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: const Color(0xFF4C4546)),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final items = Column(
              children: [
                for (var i = 0; i < cart.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _CartItemCard(
                      item: cart[i],
                      imageUrl: _itemImages[i % _itemImages.length],
                      onUpdateQuantity: onUpdateQuantity,
                    ),
                  ),
              ],
            );

            final summary = _OrderSummaryCard(
              total: total,
              onCheckout: () => onCheckout(context),
            );

            if (!isWide) {
              return Column(
                children: [
                  items,
                  summary,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 8, child: items),
                const SizedBox(width: 24),
                Expanded(flex: 4, child: summary),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.imageUrl,
    required this.onUpdateQuantity,
  });

  final CartItem item;
  final String imageUrl;
  final void Function(Product, int) onUpdateQuantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;
          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Color: Neutral',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: const Color(0xFF4C4546)),
                        ),
                        Text(
                          'Size: M',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: const Color(0xFF4C4546)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatCurrency(item.product.price),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => onUpdateQuantity(
                            item.product,
                            item.quantity - 1,
                          ),
                          icon: const Icon(Icons.remove, size: 18),
                        ),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${item.quantity}',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        IconButton(
                          onPressed: () => onUpdateQuantity(
                            item.product,
                            item.quantity + 1,
                          ),
                          icon: const Icon(Icons.add, size: 18),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Save for Later'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: const Color(0xFF4C4546)),
                    ),
                  ),
                ],
              ),
            ],
          );

          return isWide
              ? Row(
                  children: [
                    _CartImage(imageUrl: imageUrl),
                    const SizedBox(width: 16),
                    Expanded(child: content),
                  ],
                )
              : Column(
                  children: [
                    _CartImage(imageUrl: imageUrl),
                    const SizedBox(height: 16),
                    content,
                  ],
                );
        },
      ),
    );
  }
}

class _CartImage extends StatelessWidget {
  const _CartImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.total, required this.onCheckout});

  final double total;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'Subtotal',
            value: formatCurrency(total),
          ),
          _SummaryRow(
            label: 'Estimated Shipping',
            value: 'Calculated at checkout',
          ),
          _SummaryRow(label: 'Tax', value: 'Calculated at checkout'),
          const Divider(height: 32),
          _SummaryRow(
            label: 'Total',
            value: formatCurrency(total),
            isEmphasis: true,
          ),
          const SizedBox(height: 16),
          Text(
            'Promo Code',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: const Color(0xFF4C4546)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter code',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                child: Text(
                  'Apply'.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: Text(
                'Proceed to Checkout'.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isEmphasis = false,
  });

  final String label;
  final String value;
  final bool isEmphasis;

  @override
  Widget build(BuildContext context) {
    final style = isEmphasis
        ? Theme.of(context).textTheme.headlineSmall
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: style?.copyWith(color: const Color(0xFF4C4546)),
            ),
          ),
          const SizedBox(width: 12),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart, size: 56, color: Color(0xFF4C4546)),
            const SizedBox(height: 16),
            Text('Your cart is empty',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Discover our latest collection and find something to add.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: const Color(0xFF4C4546)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onContinue,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                side: const BorderSide(color: Colors.black),
              ),
              child: Text(
                'Continue Shopping'.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
