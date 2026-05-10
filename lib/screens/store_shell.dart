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
    Future<void> requireLogin(
      BuildContext context,
      VoidCallback onAuthenticated,
    ) async {
      if (controller.isLoggedIn) {
        onAuthenticated();
        return;
      }

      final email = await Navigator.of(
        context,
      ).push<String>(MaterialPageRoute(builder: (_) => const LoginScreen()));

      if (email != null && email.isNotEmpty) {
        controller.login(email);
        onAuthenticated();
      }
    }

    final pages = [
      HomeScreen(
        products: controller.products,
        onAddToCart: (context, product) =>
            requireLogin(context, () => controller.addToCart(product)),
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
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(letterSpacing: 2),
        ),
        actions: [
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
      bottomNavigationBar: _BottomNavBar(
        currentIndex: controller.navIndex,
        onTap: controller.setNavIndex,
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            label: 'Home',
            icon: Icons.home_outlined,
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _BottomNavItem(
            label: 'Cart',
            icon: Icons.shopping_cart_outlined,
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _BottomNavItem(
            label: 'Profile',
            icon: Icons.person,
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).colorScheme.primary;
    final inactiveColor = const Color(0xFF7E7576);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive ? activeColor : inactiveColor,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
