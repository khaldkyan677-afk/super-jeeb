import 'package:flutter/material.dart';
import 'client_app.dart';

class SearchDiscoveryScreen extends StatefulWidget {
  const SearchDiscoveryScreen({super.key});

  @override
  State<SearchDiscoveryScreen> createState() => _SearchDiscoveryScreenState();
}

class _SearchDiscoveryScreenState extends State<SearchDiscoveryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: const Text('استكشف',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.white),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: const Color(0xFFEF233C),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          isScrollable: true,
          labelStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'الأقسام'),
            Tab(text: 'العروض'),
            Tab(text: 'الأعلى تقييماً'),
            Tab(text: 'الماركات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _CategoriesTab(),
          _OffersTab(),
          _TopRatedTab(),
          _BrandsTab(),
        ],
      ),
    );
  }
}

// ============================================================
// 1. تبويب الأقسام
// ============================================================
class _CategoriesTab extends StatelessWidget {
  const _CategoriesTab();

  final categories = const [
    {
      'name': 'مطاعم',
      'icon': Icons.restaurant,
      'color': Color(0xFFEF233C),
      'count': 45,
    },
    {
      'name': 'سوبرماركت',
      'icon': Icons.shopping_cart,
      'color': Color(0xFF25D366),
      'count': 32,
    },
    {
      'name': 'صيدليات',
      'icon': Icons.local_pharmacy,
      'color': Color(0xFF2196F3),
      'count': 28,
    },
    {
      'name': 'ملابس',
      'icon': Icons.checkroom,
      'color': Color(0xFF9C27B0),
      'count': 67,
    },
    {
      'name': 'إلكترونيات',
      'icon': Icons.phone_android,
      'color': Color(0xFF2B2D42),
      'count': 51,
    },
    {
      'name': 'عطور',
      'icon': Icons.spa,
      'color': Color(0xFFD4AF37),
      'count': 24,
    },
    {
      'name': 'مكسرات',
      'icon': Icons.eco,
      'color': Color(0xFF8D6E63),
      'count': 18,
    },
    {
      'name': 'بقالة',
      'icon': Icons.bakery_dining,
      'color': Colors.orange,
      'count': 39,
    },
    {
      'name': 'ورد وزهور',
      'icon': Icons.local_florist,
      'color': Color(0xFFE91E63),
      'count': 12,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05), blurRadius: 8),
              ],
            ),
            child: TextField(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SearchResultsScreen()),
              ),
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'ابحث عن متجر أو منتج...',
                hintStyle: TextStyle(fontSize: 13),
                prefixIcon:
                    Icon(Icons.search, color: Color(0xFFEF233C)),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('تصفح الأقسام',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2D42))),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: categories.length,
            itemBuilder: (context, i) => _categoryCard(categories[i]),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(Map<String, dynamic> cat) {
    final color = cat['color'] as Color;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(cat['icon'] as IconData, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(cat['name'],
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text('${cat['count']} متجر',
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ============================================================
// 2. تبويب العروض
// ============================================================
class _OffersTab extends StatelessWidget {
  const _OffersTab();

  @override
  Widget build(BuildContext context) {
    final offers = [
      {
        'title': 'خصم 20%',
        'subtitle': 'على جميع العطور',
        'merchant': 'متجر العطور الفاخرة',
        'image': Icons.spa,
        'color': Color(0xFFD4AF37),
        'expires': '3 أيام',
      },
      {
        'title': 'اشترِ 2 واحصل على 1',
        'subtitle': 'على المكسرات',
        'merchant': 'متجر المكسرات',
        'image': Icons.eco,
        'color': Color(0xFF8D6E63),
        'expires': '5 أيام',
      },
      {
        'title': 'توصيل مجاني',
        'subtitle': 'للطلبات أكثر من 10,000',
        'merchant': 'جميع المتاجر',
        'image': Icons.local_shipping,
        'color': Color(0xFF25D366),
        'expires': '7 أيام',
      },
      {
        'title': 'خصم 15%',
        'subtitle': 'على الإلكترونيات',
        'merchant': 'متجر الإلكترونيات',
        'image': Icons.phone_android,
        'color': Color(0xFF2B2D42),
        'expires': '2 أيام',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: offers.length,
      itemBuilder: (context, i) => _offerCard(offers[i]),
    );
  }

  Widget _offerCard(Map<String, dynamic> o) {
    final color = o['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 20,
                  top: 20,
                  child: Icon(o['image'] as IconData,
                      color: Colors.white.withOpacity(0.3), size: 100),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('⏱️ ${o['expires']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                      Text(o['title'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(o['subtitle'],
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.storefront,
                    color: Color(0xFFEF233C), size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(o['merchant'],
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    minimumSize: const Size(0, 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {},
                  child: const Text('استفد الآن',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 3. تبويب الأعلى تقييماً
// ============================================================
class _TopRatedTab extends StatelessWidget {
  const _TopRatedTab();

  @override
  Widget build(BuildContext context) {
    final merchants = [
      {
        'name': 'متجر الأناقة',
        'category': 'ملابس',
        'rating': 4.9,
        'reviews': 245,
        'icon': Icons.checkroom,
        'color': Color(0xFF9C27B0),
      },
      {
        'name': 'متجر العطور الفاخرة',
        'category': 'عطور',
        'rating': 4.8,
        'reviews': 189,
        'icon': Icons.spa,
        'color': Color(0xFFD4AF37),
      },
      {
        'name': 'متجر الإلكترونيات',
        'category': 'إلكترونيات',
        'rating': 4.8,
        'reviews': 312,
        'icon': Icons.phone_android,
        'color': Color(0xFF2B2D42),
      },
      {
        'name': 'صيدلية الحياة',
        'category': 'صيدليات',
        'rating': 4.7,
        'reviews': 156,
        'icon': Icons.local_pharmacy,
        'color': Color(0xFF2196F3),
      },
      {
        'name': 'سوبرماركت النور',
        'category': 'سوبرماركت',
        'rating': 4.7,
        'reviews': 428,
        'icon': Icons.shopping_cart,
        'color': Color(0xFF25D366),
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: merchants.length,
      itemBuilder: (context, i) => _merchantCard(merchants[i], i + 1),
    );
  }

  Widget _merchantCard(Map<String, dynamic> m, int rank) {
    final color = m['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? const Color(0xFFD4AF37)
                  : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('#$rank',
                  style: TextStyle(
                      color: rank <= 3 ? Colors.white : Colors.black54,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(m['icon'] as IconData, color: color, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m['name'],
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(m['category'],
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Colors.amber, size: 14),
                    const SizedBox(width: 3),
                    Text('${m['rating']}',
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Text('(${m['reviews']} تقييم)',
                        style: const TextStyle(
                            fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              color: Colors.grey, size: 14),
        ],
      ),
    );
  }
}

// ============================================================
// 4. تبويب الماركات
// ============================================================
class _BrandsTab extends StatelessWidget {
  const _BrandsTab();

  final brands = const [
    {'name': 'Samsung', 'icon': Icons.phone_android},
    {'name': 'Apple', 'icon': Icons.apple},
    {'name': 'Nike', 'icon': Icons.sports_soccer},
    {'name': 'Adidas', 'icon': Icons.sports_soccer},
    {'name': 'Zara', 'icon': Icons.checkroom},
    {'name': 'H&M', 'icon': Icons.checkroom},
    {'name': 'Chanel', 'icon': Icons.spa},
    {'name': 'Dior', 'icon': Icons.spa},
    {'name': 'Nestlé', 'icon': Icons.eco},
    {'name': 'Pepsi', 'icon': Icons.local_drink},
    {'name': 'Lays', 'icon': Icons.restaurant},
    {'name': 'Dell', 'icon': Icons.computer},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('تسوّق حسب الماركة',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2D42))),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: brands.length,
            itemBuilder: (context, i) => _brandCard(brands[i]),
          ),
        ],
      ),
    );
  }

  Widget _brandCard(Map<String, dynamic> b) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(b['icon'] as IconData,
              color: const Color(0xFF2B2D42), size: 36),
          const SizedBox(height: 8),
          Text(b['name'],
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ============================================================
// شاشة نتائج البحث
// ============================================================
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final _searchCtrl = TextEditingController();
  String _sortBy = 'الأعلى تقييماً';
  bool _filterOpen = false;

  final _products = [
    {'name': 'قميص رجالي', 'price': 8000, 'rating': 4.8, 'merchant': 'متجر الأناقة', 'icon': Icons.checkroom},
    {'name': 'بنطلون جينز', 'price': 12000, 'rating': 4.6, 'merchant': 'متجر الأناقة', 'icon': Icons.checkroom},
    {'name': 'هاتف ذكي', 'price': 150000, 'rating': 4.9, 'merchant': 'متجر الإلكترونيات', 'icon': Icons.phone_android},
    {'name': 'عطر فاخر', 'price': 12000, 'rating': 4.7, 'merchant': 'متجر العطور', 'icon': Icons.spa},
    {'name': 'حقيبة نسائية', 'price': 18000, 'rating': 4.5, 'merchant': 'متجر الأناقة', 'icon': Icons.shopping_bag},
    {'name': 'ساعة رقمية', 'price': 25000, 'rating': 4.4, 'merchant': 'متجر الإلكترونيات', 'icon': Icons.watch},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        leading: const BackButton(color: Colors.white),
        title: TextField(
          controller: _searchCtrl,
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'ابحث...',
            hintStyle: TextStyle(color: Colors.white60, fontSize: 13),
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
                _filterOpen ? Icons.tune : Icons.tune_outlined,
                color: Colors.white),
            onPressed: () =>
                setState(() => _filterOpen = !_filterOpen),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_filterOpen) _filterSection(),
          _sortBar(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: _products.length,
              itemBuilder: (context, i) => _productCard(_products[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('الفئات',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['ملابس', 'إلكترونيات', 'عطور', 'منزل', 'صحة']
                .map((c) => FilterChip(
                      label: Text(c,
                          style: const TextStyle(fontSize: 11)),
                      onSelected: (_) {},
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text('نطاق السعر',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'من',
                    hintStyle: const TextStyle(fontSize: 12),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('إلى'),
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'إلى',
                    hintStyle: const TextStyle(fontSize: 12),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sortBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.sort, color: Color(0xFFEF233C), size: 18),
          const SizedBox(width: 8),
          const Text('الترتيب:',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: _sortBy,
            underline: const SizedBox(),
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2B2D42),
                fontWeight: FontWeight.bold),
            items: ['الأعلى تقييماً', 'الأقرب', 'الأقل سعراً', 'الأعلى سعراً']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _sortBy = v!),
          ),
          const Spacer(),
          Text('${_products.length} نتيجة',
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _productCard(Map<String, dynamic> p) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(
            name: p['name'] as String,
            price: p['price'] as int,
            merchant: p['merchant'] as String,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Icon(p['icon'] as IconData,
                      size: 60, color: const Color(0xFF2B2D42)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['name'],
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(p['merchant'],
                      style: const TextStyle(
                          fontSize: 10, color: Colors.grey),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Colors.amber, size: 12),
                      const SizedBox(width: 2),
                      Text('${p['rating']}',
                          style: const TextStyle(fontSize: 10)),
                      const Spacer(),
                      Text('${p['price']} YER',
                          style: const TextStyle(
                              color: Color(0xFFEF233C),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
