import 'package:flutter/material.dart';

import '../models/order.dart';
import '../utils/formatters.dart';

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
