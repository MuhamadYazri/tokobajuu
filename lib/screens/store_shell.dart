import 'package:flutter/material.dart';

import '../state/store_controller.dart';
import 'cart_screen.dart';
import 'checkout_summary_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class StoreShell extends StatelessWidget {
  const StoreShell({super.key, required this.controller});

  final StoreController controller;

  @override
  Widget build(BuildContext context) {
    Future<void> requireLogin(BuildContext context, VoidCallback onAuthenticated) async {
      if (controller.isLoggedIn) {
        onAuthenticated();
        return;
      }

      final email = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );

      if (email != null && email.isNotEmpty) {
        controller.login(email);
        onAuthenticated();
      }
    }

    final pages = [
      HomeScreen(
        products: controller.products,
        onAddToCart: (context, product) => requireLogin(
          context,
          () => controller.addToCart(product),
        ),
      ),
      CartScreen(
        cart: controller.cart,
        total: controller.cartTotal,
        onUpdateQuantity: controller.updateQuantity,
        onClearCart: controller.clearCart,
        onCheckout: (context) => requireLogin(
          context,
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CheckoutSummaryScreen(
                cart: controller.cart,
                total: controller.cartTotal,
                onClearCart: controller.clearCart,
                onPlaceOrder: controller.placeOrder,
              ),
            ),
          ),
        ),
      ),
      ProfileScreen(
        orders: controller.orders,
        isLoggedIn: controller.isLoggedIn,
        userEmail: controller.userEmail,
        onLogin: controller.login,
        onLogout: controller.logout,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ESTHETIQUE',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                letterSpacing: 2,
              ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline)),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_bag_outlined),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: pages[controller.navIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.navIndex,
        onTap: controller.setNavIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
