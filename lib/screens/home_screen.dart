import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/formatters.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.products, required this.onAddToCart});

  final List<Product> products;
  final void Function(BuildContext, Product) onAddToCart;
  static const String _heroImageUrl =
      'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1400&q=80';
  static const List<_CategoryTile> _categories = [
    _CategoryTile(
      title: 'Essentials',
      subtitle: 'Wardrobe foundations',
      imageUrl:
          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=900&q=80',
      isWide: true,
    ),
    _CategoryTile(
      title: 'Outerwear',
      subtitle: 'Layered comfort',
      imageUrl:
          'https://images.unsplash.com/photo-1520975954732-35dd222996f1?auto=format&fit=crop&w=900&q=80',
    ),
    _CategoryTile(
      title: 'Accessories',
      subtitle: 'Quiet accents',
      imageUrl:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=900&q=80',
    ),
  ];
  static const List<String> _trendingImages = [
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=900&q=80',
    'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&w=900&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    final trendingProducts = products.take(_trendingImages.length).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: _HeroSection(imageUrl: _heroImageUrl),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const _SectionHeader(
            title: 'Curated Selections',
            actionLabel: 'Explore',
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _BentoGrid(categories: _categories),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const _SectionHeader(
            title: 'Trending Now',
            actionLabel: 'View All',
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 320,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: trendingProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final product = trendingProducts[index];
              return _TrendingCard(
                product: product,
                imageUrl: _trendingImages[index],
                onAddToCart: () => onAddToCart(context, product),
                onOpen: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(
                      product: product,
                      onAddToCart: onAddToCart,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          SizedBox(
            height: 360,
            width: double.infinity,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          Container(
            height: 360,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.65), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AUTUMN / WINTER',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  'New Arrivals',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Minimal pieces built for everyday calm and confidence.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Shop Collection'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
  });

  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        TextButton(
          onPressed: () {},
          child: Text(actionLabel.toUpperCase()),
        ),
      ],
    );
  }
}

class _BentoGrid extends StatelessWidget {
  const _BentoGrid({required this.categories});

  final List<_CategoryTile> categories;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        if (!isWide) {
          return Column(
            children: categories
                .map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: _CategoryCard(item: item),
                      ),
                    ))
                .toList(),
          );
        }

        return SizedBox(
          height: 420,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: _CategoryCard(item: categories[0]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: _CategoryCard(item: categories[1])),
                    const SizedBox(height: 16),
                    Expanded(child: _CategoryCard(item: categories[2])),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryTile {
  const _CategoryTile({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.isWide = false,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isWide;
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.item});

  final _CategoryTile item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(item.imageUrl, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({
    required this.product,
    required this.imageUrl,
    required this.onAddToCart,
    required this.onOpen,
  });

  final Product product;
  final String imageUrl;
  final VoidCallback onAddToCart;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onOpen,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: IconButton(
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          onPressed: onAddToCart,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(product.name, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(formatCurrency(product.price),
              style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
