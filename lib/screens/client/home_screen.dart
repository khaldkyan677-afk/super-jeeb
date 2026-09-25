import 'supermarket/grocery_screen.dart';
import 'supermarket/stores_screen.dart';
import 'supermarket/restaurants_screen.dart';
import 'supermarket/supermarket_screen.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/store_logo_animated.dart';
import '../../widgets/location_picker.dart';
import 'taxi_screen.dart';
import '../onboarding_location_screen.dart';
import '../../services/location_service.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});
  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  final PageController _bannerController = PageController();
  int _bannerIndex = 0;
  bool _showLocationOverlay = false;
  bool _dismissedOnce = false;
  String _currentCity = 'صنعاء';
  String _currentCurrency = 'قديم';

  final List<Map<String, String>> _banners = [
    {'title': 'عروض خاصة', 'subtitle': 'خصومات تصل إلى 50%'},
    {'title': 'توصيل مجاني', 'subtitle': 'على أول طلب لك'},
    {'title': 'نقاط مضاعفة', 'subtitle': 'عند الشراء هذا الأسبوع'},
  ];

  // الأقسام — ستُجلب من API لاحقاً
  final List<Map<String, dynamic>> _services = [
    {'name': 'سوبرماركت', 'icon': Icons.shopping_cart},
    {'name': 'صيدلية', 'icon': Icons.local_pharmacy},
    {'name': 'مطاعم', 'icon': Icons.restaurant},
    {'name': 'متاجر', 'icon': Icons.storefront},
    {'name': 'تاكسي', 'icon': Icons.local_taxi},
    {'name': 'طرود', 'icon': Icons.local_shipping},
    {'name': 'فرزة', 'icon': Icons.airport_shuttle},
    {'name': 'بقاة', 'icon': Icons.bakery_dining},
  ];

  @override
  void initState() {
    super.initState();
    // إذا ما فيه موقع محفوظ → اظهر النافذة
    if (!LocationService.hasLocation) {
      _showLocationOverlay = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMainScaffold(),
        if (_showLocationOverlay)
          Positioned.fill(
            child: OnboardingLocationScreen(
              onComplete: () => setState(() {
                _showLocationOverlay = false;
                _dismissedOnce = true;
                _currentCity = LocationService.city;
                _currentCurrency = LocationService.currency;
              }),
              onSkip: () => setState(() {
                _showLocationOverlay = false;
                _dismissedOnce = true;
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildMainScaffold() {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildBanner(),
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 25),
              _buildSectionTitle('الخدمات'),
              const SizedBox(height: 12),
              _buildServicesGrid(),
              const SizedBox(height: 25),
              _buildSectionTitle('متاجر قريبة منك'),
              const SizedBox(height: 12),
              _buildFeaturedStores(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(children: [
      const SizedBox(width: 55, height: 55, child: StoreLogoAnimated(size: 50)),
      const SizedBox(width: 12),
      Expanded(
        child: InkWell(
          onTap: _changeLocation,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(children: [
              const Icon(Icons.location_on, color: AppTheme.red, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text('$_currentCity • $_currentCurrency',
                  style: TextStyle(color: AppTheme.white, fontFamily: 'Cairo', fontSize: 13),
                  overflow: TextOverflow.ellipsis),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
            ]),
          ),
        ),
      ),
      const SizedBox(width: 8),
      InkWell(
        onTap: () => _showComingSoon('الإشعارات'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Stack(children: [
            const Icon(Icons.notifications_outlined, color: AppTheme.white, size: 22),
            Positioned(
              right: 0, top: 0,
              child: Container(width: 8, height: 8,
                decoration: const BoxDecoration(color: AppTheme.red, shape: BoxShape.circle)),
            ),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildBanner() {
    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: _bannerController,
        onPageChanged: (i) => setState(() => _bannerIndex = i),
        itemCount: _banners.length,
        itemBuilder: (_, i) => _bannerCard(_banners[i]),
      ),
    );
  }

  Widget _bannerCard(Map<String, String> banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.charcoal, AppTheme.red.withOpacity(0.7)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.red.withOpacity(0.3)),
      ),
      child: Stack(children: [
        Positioned(
          right: -20, top: -20,
          child: Container(width: 120, height: 120,
            decoration: BoxDecoration(color: AppTheme.red.withOpacity(0.15), shape: BoxShape.circle)),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                const Icon(Icons.local_fire_department, color: AppTheme.white, size: 24),
                const SizedBox(width: 8),
                Text(banner['title'] ?? '',
                  style: TextStyle(color: AppTheme.white, fontSize: 20,
                    fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              ]),
              const SizedBox(height: 8),
              Text(banner['subtitle'] ?? '',
                style: TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Cairo')),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: AppTheme.white,
                  borderRadius: BorderRadius.circular(20)),
                child: Text('اكتشف الآن',
                  style: TextStyle(color: AppTheme.dark, fontSize: 12,
                    fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildQuickActions() {
    return Row(children: [
      Expanded(child: _quickCard(Icons.local_shipping, 'Super Express', 'شحن آمن')),
      const SizedBox(width: 12),
      Expanded(child: _quickCard(Icons.edit_note, 'اشترِ لي', 'المندوب يشتري')),
    ]);
  }

  Widget _quickCard(IconData icon, String title, String subtitle) {
    return InkWell(
      onTap: () => _showComingSoon(title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppTheme.red.withOpacity(0.15), shape: BoxShape.circle),
          child: Icon(icon, color: AppTheme.red, size: 24),
        ),
        const SizedBox(height: 12),
        Text(title, style: TextStyle(color: AppTheme.white, fontSize: 14,
          fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: Colors.white54,
          fontSize: 11, fontFamily: 'Cairo')),
      ]),
    ));
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: AppTheme.white, fontSize: 18,
          fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
        Text('عرض الكل', style: TextStyle(color: AppTheme.red,
          fontSize: 12, fontFamily: 'Cairo')),
      ],
    );
  }

  Widget _buildServicesGrid() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      children: _services.map((s) => _serviceCard(s)).toList(),
    );
  }

  Widget _serviceCard(Map<String, dynamic> service) {
    return InkWell(
      onTap: () => _openService(service['name']),
      borderRadius: BorderRadius.circular(16),
      child: Column(children: [
        Container(
          height: 65, width: 65,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Icon(service['icon'], color: AppTheme.red, size: 28),
        ),
        const SizedBox(height: 6),
        Text(service['name'], style: TextStyle(color: AppTheme.white,
          fontSize: 11, fontFamily: 'Cairo'), overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  void _openService(String name) {
    // منع التسوق بدون موقع
    if (!LocationService.hasLocation) {
      setState(() => _showLocationOverlay = true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('حدد موقعك أولاً للتسوق',
          style: TextStyle(fontFamily: 'Cairo', color: AppTheme.white)),
        backgroundColor: AppTheme.red,
        duration: const Duration(seconds: 2),
      ));
      return;
    }

    switch (name) {
      case 'تاكسي':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TaxiScreen()));
        break;
      case 'سوبرماركت':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SupermarketScreen()));
        break;
      case 'مطاعم':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantsScreen()));
        break;
      case 'متاجر':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const StoresScreen()));
        break;
      case 'بقاة':
      case 'بقالة':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GroceryScreen()));
        break;
      default:
        _showComingSoon(name);
    }
  }

  Future<void> _changeLocation() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LocationPicker(currentCity: _currentCity),
    );
    if (result != null && mounted) {
      setState(() {
        _currentCity = result['city'] ?? _currentCity;
        _currentCurrency = result['currency'] ?? _currentCurrency;
      });
    }
  }

  void _showComingSoon(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('سيتم تفعيل "$name" قريباً',
          style: TextStyle(fontFamily: 'Cairo', color: AppTheme.white)),
        backgroundColor: AppTheme.surface,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildFeaturedStores() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (_, i) => Container(
          width: 160,
          margin: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.charcoal,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Center(child: Icon(Icons.storefront, color: AppTheme.red, size: 40)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('متجر ${i + 1}', style: TextStyle(color: AppTheme.white,
                  fontSize: 13, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star, color: Colors.amber, size: 12),
                  const SizedBox(width: 4),
                  Text('4.${i + 5}', style: TextStyle(color: Colors.white54,
                    fontSize: 10, fontFamily: 'Cairo')),
                  const Spacer(),
                  const Icon(Icons.access_time, color: Colors.white54, size: 12),
                  const SizedBox(width: 4),
                  Text('${15 + i * 5}د', style: TextStyle(color: Colors.white54,
                    fontSize: 10, fontFamily: 'Cairo')),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
