import 'package:flutter/material.dart';

import '../models/order.dart';
import 'login_screen.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.orders,
    required this.isLoggedIn,
    required this.userEmail,
    required this.onLogin,
    required this.onLogout,
  });

  final List<Order> orders;
  final bool isLoggedIn;
  final String userEmail;
  final ValueChanged<String> onLogin;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
        const SizedBox(height: 12),
        Text(
          isLoggedIn ? 'Signed In' : 'Guest User',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        Text(
          isLoggedIn ? userEmail : 'guest@email.com',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        if (!isLoggedIn)
          ElevatedButton(
            onPressed: () async {
              final email = await Navigator.of(context).push<String>(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
              if (email != null && email.isNotEmpty) {
                onLogin(email);
              }
            },
            child: const Text('Login'),
          )
        else
          TextButton(
            onPressed: onLogout,
            child: const Text('Logout'),
          ),
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
