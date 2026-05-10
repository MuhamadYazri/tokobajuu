import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../utils/formatters.dart';

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
    const orderImages = [
      'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1520975954732-35dd222996f1?auto=format&fit=crop&w=900&q=80',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ESTHETIQUE',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                letterSpacing: 2,
              ),
        ),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_bag)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          _StepperRow(),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;
              final details = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(
                    title: 'Shipping Information',
                    actionLabel: 'EDIT',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Eleanor Vance',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text('1000 Hill House Road',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: const Color(0xFF4C4546))),
                        Text('Apartment 4B',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: const Color(0xFF4C4546))),
                        Text('San Francisco, CA 94109',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: const Color(0xFF4C4546))),
                        const SizedBox(height: 8),
                        Text('Standard Shipping (3-5 Business Days)',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: const Color(0xFF4C4546))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(
                    title: 'Payment Method',
                    actionLabel: 'EDIT',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const [
                      _PaymentOption(
                        title: '•••• 4242',
                        subtitle: 'Expires 12/26',
                        icon: Icons.credit_card,
                        isActive: true,
                      ),
                      _PaymentOption(
                        title: 'Apple Pay',
                        subtitle: '',
                        icon: Icons.contactless,
                        isActive: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionHeader(title: 'Order Details'),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      for (var i = 0; i < cart.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _OrderItemRow(
                            item: cart[i],
                            imageUrl: orderImages[i % orderImages.length],
                          ),
                        ),
                    ],
                  ),
                ],
              );

              final summary = _SummaryPanel(
                total: total,
                shipping: shipping,
                grandTotal: grandTotal,
                onPlaceOrder: cart.isEmpty
                    ? null
                    : () {
                        onPlaceOrder();
                        onClearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order placed successfully.'),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
              );

              if (!isWide) {
                return Column(
                  children: [
                    details,
                    const SizedBox(height: 24),
                    summary,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: details),
                  const SizedBox(width: 32),
                  Expanded(flex: 5, child: summary),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inactive = Theme.of(context)
        .textTheme
        .labelSmall
        ?.copyWith(color: const Color(0xFF4C4546));
    final active = Theme.of(context)
        .textTheme
        .labelSmall
        ?.copyWith(color: Colors.black);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('SHIPPING', style: inactive),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.remove, size: 16, color: Color(0xFFCFC4C5)),
        ),
        Text('PAYMENT', style: inactive),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Icon(Icons.remove, size: 16, color: Color(0xFFCFC4C5)),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 4),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 2)),
          ),
          child: Text('REVIEW', style: active),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onTap});

  final String title;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (actionLabel != null)
          TextButton(
            onPressed: onTap,
            child: Text(
              actionLabel!,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: const Color(0xFF4C4546)),
            ),
          ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});

  final Widget child;

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
      child: child,
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isActive,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? Colors.black
              : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: isActive ? Colors.black : const Color(0xFF4C4546)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isActive ? Colors.black : const Color(0xFF4C4546),
                      ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: const Color(0xFF4C4546)),
                  ),
              ],
            ),
          ),
          if (isActive)
            const Icon(Icons.check_circle, color: Colors.black, size: 20),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow({required this.item, required this.imageUrl});

  final CartItem item;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 96,
          height: 128,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.name,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(
                'Color: Neutral',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: const Color(0xFF4C4546)),
              ),
              Text(
                'Qty: ${item.quantity}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: const Color(0xFF4C4546)),
              ),
            ],
          ),
        ),
        Text(
          formatCurrency(item.product.price * item.quantity),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({
    required this.total,
    required this.shipping,
    required this.grandTotal,
    required this.onPlaceOrder,
  });

  final double total;
  final double shipping;
  final double grandTotal;
  final VoidCallback? onPlaceOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _LineItem(label: 'Subtotal', value: formatCurrency(total)),
          _LineItem(label: 'Standard Shipping', value: 'Complimentary'),
          _LineItem(label: 'Estimated Tax', value: formatCurrency(shipping)),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Total', style: Theme.of(context).textTheme.bodyLarge),
              Text(
                formatCurrency(grandTotal),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPlaceOrder,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.lock, size: 18),
              label: Text(
                'PLACE ORDER',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield, size: 14, color: Color(0xFF4C4546)),
              const SizedBox(width: 6),
              Text(
                'Secure Encrypted Transaction'.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: const Color(0xFF4C4546), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineItem extends StatelessWidget {
  const _LineItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: const Color(0xFF4C4546)),
          ),
          Text(value, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
