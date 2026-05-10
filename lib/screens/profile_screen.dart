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

  static const String _avatarUrl =
      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=600&q=80';
  static const String _orderImageUrl =
      'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=600&q=80';

  @override
  Widget build(BuildContext context) {
    final name = isLoggedIn ? 'Eleanor Vance' : 'Guest User';
    final email = isLoggedIn ? userEmail : 'guest@email.com';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _ProfileHeader(
          name: name,
          email: email,
          avatarUrl: _avatarUrl,
          isLoggedIn: isLoggedIn,
          onLogin: onLogin,
        ),
        const SizedBox(height: 24),
        _SectionLabel(text: 'Dashboard'),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;
            final cardSpacing = const SizedBox(height: 16);

            if (!isWide) {
              return Column(
                children: [
                  _OrderHistoryCard(
                    orders: orders,
                    imageUrl: _orderImageUrl,
                    onOpen: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OrderHistoryScreen(orders: orders),
                      ),
                    ),
                  ),
                  cardSpacing,
                  const _AddressCard(),
                  cardSpacing,
                  const _PaymentCard(),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _OrderHistoryCard(
                    orders: orders,
                    imageUrl: _orderImageUrl,
                    onOpen: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OrderHistoryScreen(orders: orders),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(child: _AddressCard()),
                const SizedBox(width: 16),
                const Expanded(child: _PaymentCard()),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        _SectionLabel(text: 'Account Settings'),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.person_outline,
          title: 'Personal Information',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.lock_outline,
          title: 'Security & Password',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _NotificationTile(),
        const SizedBox(height: 24),
        _SectionLabel(text: 'Support'),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;
            if (!isWide) {
              return Column(
                children: const [
                  _SupportTile(icon: Icons.help_outline, label: 'Help Center'),
                  SizedBox(height: 12),
                  _SupportTile(
                    icon: Icons.chat_bubble_outline,
                    label: 'FAQ & Contact',
                  ),
                ],
              );
            }
            return Row(
              children: const [
                Expanded(
                  child: _SupportTile(icon: Icons.help_outline, label: 'Help Center'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _SupportTile(
                    icon: Icons.chat_bubble_outline,
                    label: 'FAQ & Contact',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        if (isLoggedIn)
          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout, color: Color(0xFFBA1A1A)),
            label: Text(
              'LOG OUT',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: const Color(0xFFBA1A1A)),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFBA1A1A)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          )
        else
          ElevatedButton(
            onPressed: () async {
              final email = await Navigator.of(context).push<String>(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
              if (email != null && email.isNotEmpty) {
                onLogin(email);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Login'.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.isLoggedIn,
    required this.onLogin,
  });

  final String name;
  final String email;
  final String avatarUrl;
  final bool isLoggedIn;
  final ValueChanged<String> onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(48),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(avatarUrl, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: const Color(0xFF4C4546)),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, size: 16, color: Colors.black),
                      const SizedBox(width: 6),
                      Text(
                        isLoggedIn ? 'NOIR MEMBER' : 'GUEST MEMBER',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context)
          .textTheme
          .labelSmall
          ?.copyWith(color: const Color(0xFF4C4546)),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  const _OrderHistoryCard({
    required this.orders,
    required this.imageUrl,
    required this.onOpen,
  });

  final List<Order> orders;
  final String imageUrl;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final hasOrders = orders.isNotEmpty;

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order History',
                  style: Theme.of(context).textTheme.headlineSmall),
              IconButton(
                onPressed: onOpen,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasOrders ? 'Delivered • Oct 12' : 'No orders yet',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: const Color(0xFF4C4546)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasOrders ? 'Hydration Serum set' : 'Start a new order',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasOrders ? 'Rp 145000' : 'Explore new arrivals',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: const Color(0xFF4C4546)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard();

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.black),
                  const SizedBox(width: 8),
                  Text('Addresses',
                      style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Default Billing & Shipping',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: const Color(0xFF4C4546)),
          ),
          const SizedBox(height: 8),
          Text(
            '1245 Gallery Way, Apt 3B\nNew York, NY 10012\nUnited States',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard();

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.credit_card, color: Colors.black),
                  const SizedBox(width: 8),
                  Text('Payment',
                      style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          'VISA',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontSize: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('•••• 4242',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                Text(
                  '04/26',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: const Color(0xFF4C4546)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: _SurfaceCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF4C4546)),
                const SizedBox(width: 12),
                Text(title, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF7E7576)),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatefulWidget {
  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications, color: Color(0xFF4C4546)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notifications',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    'Order updates & offers',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: const Color(0xFF4C4546)),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: _enabled,
            onChanged: (value) => setState(() => _enabled = value),
          ),
        ],
      ),
    );
  }
}

class _SupportTile extends StatelessWidget {
  const _SupportTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4C4546)),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
