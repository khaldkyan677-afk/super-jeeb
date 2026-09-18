import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<Map<String, dynamic>> _favorites = [
    {
      'name': 'قميص رجالي فاخر',
      'price': 8000,
      'merchant': 'متجر الأناقة',
      'icon': Icons.checkroom,
    },
    {
      'name': 'هاتف ذكي حديث',
      'price': 150000,
      'merchant': 'متجر الإلكترونيات',
      'icon': Icons.phone_android,
    },
    {
      'name': 'عطر شرقي فاخر',
      'price': 12000,
      'merchant': 'متجر العطور',
      'icon': Icons.spa,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: Row(
          children: [
            const Icon(Icons.favorite, color: Color(0xFFEF233C), size: 22),
            const SizedBox(width: 8),
            const Text(
              'المفضلة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFEF233C),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_favorites.length}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: _favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 15),
                  Text(
                    'لا توجد منتجات في المفضلة',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _favorites.length,
              itemBuilder: (context, i) => _card(i),
            ),
    );
  }

  Widget _card(int i) {
    final p = _favorites[i];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              p['icon'] as IconData,
              color: const Color(0xFF2B2D42),
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p['name'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  p['merchant'],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  '${p['price']} YER',
                  style: const TextStyle(
                    color: Color(0xFFEF233C),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Color(0xFFEF233C),
                  size: 22,
                ),
                onPressed: () {
                  setState(() => _favorites.removeAt(i));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم الإزالة من المفضلة'),
                      backgroundColor: Color(0xFFEF233C),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_shopping_cart,
                  color: Color(0xFF25D366),
                  size: 22,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🛒 تم الإضافة للسلة'),
                      backgroundColor: Color(0xFF25D366),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
