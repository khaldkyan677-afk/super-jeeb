import 'package:flutter/material.dart';

class CartCheckoutScreen extends StatefulWidget {
  const CartCheckoutScreen({super.key});

  @override
  State<CartCheckoutScreen> createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends State<CartCheckoutScreen> {
  int _step = 0; // 0=cart, 1=address, 2=payment, 3=confirm

  final List<Map<String, dynamic>> _carts = [
    {
      'merchant': 'متجر الأناقة',
      'merchantId': 1,
      'delivery': 1500,
      'items': [
        {
          'name': 'قميص رجالي',
          'price': 8000,
          'qty': 1,
          'icon': Icons.checkroom,
        },
        {
          'name': 'بنطلون جينز',
          'price': 12000,
          'qty': 1,
          'icon': Icons.checkroom,
        },
      ],
    },
    {
      'merchant': 'متجر الإلكترونيات',
      'merchantId': 2,
      'delivery': 2000,
      'items': [
        {
          'name': 'هاتف ذكي',
          'price': 150000,
          'qty': 1,
          'icon': Icons.phone_android,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        title: Text(
          _step == 0
              ? 'سلاتي'
              : _step == 1
                  ? 'عنوان التوصيل'
                  : _step == 2
                      ? 'طريقة الدفع'
                      : 'تأكيد الطلب',
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          _stepper(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: _step == 0
                  ? _buildCarts()
                  : _step == 1
                      ? _buildAddress()
                      : _step == 2
                          ? _buildPayment()
                          : _buildConfirm(),
            ),
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _stepper() {
    final steps = ['السلة', 'العنوان', 'الدفع', 'التأكيد'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: steps.asMap().entries.map((e) {
          final i = e.key;
          final done = i < _step;
          final active = i == _step;
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: done
                        ? const Color(0xFF25D366)
                        : active
                            ? const Color(0xFFEF233C)
                            : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: done
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 16)
                        : Text('${i + 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 6),
                Text(e.value,
                    style: TextStyle(
                        fontSize: 11,
                        color: (done || active)
                            ? const Color(0xFF2B2D42)
                            : Colors.grey,
                        fontWeight: (done || active)
                            ? FontWeight.bold
                            : FontWeight.normal)),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      color: done
                          ? const Color(0xFF25D366)
                          : Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCarts() {
    if (_carts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined,
                size: 80, color: Colors.grey),
            SizedBox(height: 15),
            Text('السلة فارغة',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      );
    }

    return Column(
      children: [
        ..._carts.asMap().entries.map((e) => _cartCard(e.key, e.value)),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _cartCard(int cartIndex, Map<String, dynamic> cart) {
    final items = cart['items'] as List;
    final delivery = cart['delivery'] as int;
    int subtotal = 0;
    for (var item in items) {
      subtotal += (item['price'] as int) * (item['qty'] as int);
    }
    final total = subtotal + delivery;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
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
          Row(
            children: [
              const Icon(Icons.storefront,
                  color: Color(0xFFEF233C), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(cart['merchant'],
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B2D42))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF233C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${items.length} منتج',
                    style: const TextStyle(
                        color: Color(0xFFEF233C),
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 20),
          ...items.asMap().entries.map((e) => _cartItem(cartIndex, e.key, e.value)),
          const Divider(height: 20),
          _row('المجموع', '$subtotal YER'),
          _row('التوصيل', '$delivery YER'),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الإجمالي',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              Text('$total YER',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFFEF233C))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cartItem(int cartIndex, int itemIndex, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item['icon'] as IconData,
                color: const Color(0xFF2B2D42), size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'],
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text('${item['price']} YER',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFFEF233C))),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove,
                      size: 18, color: Color(0xFFEF233C)),
                  onPressed: () {
                    setState(() {
                      if ((item['qty'] as int) > 1) {
                        _carts[cartIndex]['items'][itemIndex]['qty']--;
                      } else {
                        _carts[cartIndex]['items'].removeAt(itemIndex);
                        if ((_carts[cartIndex]['items'] as List).isEmpty) {
                          _carts.removeAt(cartIndex);
                        }
                      }
                    });
                  },
                ),
                Text('${item['qty']}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add,
                      size: 18, color: Color(0xFF25D366)),
                  onPressed: () {
                    setState(() {
                      _carts[cartIndex]['items'][itemIndex]['qty']++;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress() {
    final addresses = [
      {
        'title': 'المنزل',
        'address': 'صنعاء - شارع حدة - جوار مسجد النور',
        'default': true,
        'icon': Icons.home,
      },
      {
        'title': 'العمل',
        'address': 'صنعاء - شارع تعز - مجمع الأعمال',
        'default': false,
        'icon': Icons.work,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اختر عنوان التوصيل',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2D42))),
        const SizedBox(height: 15),
        ...addresses.map((a) => _addressCard(a)),
        const SizedBox(height: 15),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            side: const BorderSide(color: Color(0xFFEF233C)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => _showAddAddress(context),
          icon: const Icon(Icons.add, color: Color(0xFFEF233C)),
          label: const Text('إضافة عنوان جديد',
              style: TextStyle(
                  color: Color(0xFFEF233C),
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'ملاحظات للطلب (اختياري)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _addressCard(Map<String, dynamic> a) {
    final isDefault = a['default'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isDefault
            ? Border.all(color: const Color(0xFFEF233C), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEF233C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(a['icon'] as IconData,
                color: const Color(0xFFEF233C), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(a['title'],
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('افتراضي',
                            style: TextStyle(
                                color: Color(0xFF25D366),
                                fontSize: 8,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(a['address'],
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Radio<bool>(
            value: true,
            groupValue: isDefault,
            activeColor: const Color(0xFFEF233C),
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _buildPayment() {
    final methods = [
      {
        'title': 'كاش عند الاستلام',
        'subtitle': 'ادفع للمندوب نقداً',
        'icon': Icons.payments,
        'color': const Color(0xFF25D366),
      },
      {
        'title': 'محفظة إلكترونية',
        'subtitle': 'الكريمي، جيب، جوالي',
        'icon': Icons.account_balance_wallet,
        'color': const Color(0xFFEF233C),
      },
      {
        'title': 'بطاقة بنكية',
        'subtitle': 'Visa / Mastercard',
        'icon': Icons.credit_card,
        'color': const Color(0xFF2B2D42),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('اختر طريقة الدفع',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2D42))),
        const SizedBox(height: 15),
        ...methods.map((m) => _paymentCard(m)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('إكرامية المندوب (اختياري)',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [0, 500, 1000, 2000].map((tip) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(tip == 0 ? 'بدون' : '$tip YER',
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentCard(Map<String, dynamic> m) {
    final color = m['color'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(m['icon'] as IconData, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m['title'],
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(m['subtitle'],
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.radio_button_unchecked,
              color: Colors.grey, size: 22),
        ],
      ),
    );
  }

  Widget _buildConfirm() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              const Icon(Icons.check_circle,
                  color: Color(0xFF25D366), size: 60),
              const SizedBox(height: 15),
              const Text('جاهز للتأكيد',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('تأكد من بيانات طلبك قبل التأكيد',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              const Divider(height: 30),
              _summaryRow('عدد المتاجر', '${_carts.length}'),
              _summaryRow('عدد المنتجات',
                  '${_carts.fold<int>(0, (sum, c) => sum + (c['items'] as List).length)}'),
              _summaryRow(
                  'المجموع الكلي',
                  '${_carts.fold<int>(0, (sum, c) {
                int cartTotal = 0;
                for (var item in (c['items'] as List)) {
                  cartTotal +=
                      (item['price'] as int) * (item['qty'] as int);
                }
                return sum + cartTotal + (c['delivery'] as int);
              })} YER'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF233C),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              if (_step < 3) {
                setState(() => _step++);
              } else {
                _confirmOrder();
              }
            },
            child: Text(
              _step == 0
                  ? 'متابعة إلى العنوان'
                  : _step == 1
                      ? 'متابعة إلى الدفع'
                      : _step == 2
                          ? 'متابعة إلى التأكيد'
                          : 'تأكيد الطلب الآن',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check,
                  color: Color(0xFF25D366), size: 50),
            ),
            const SizedBox(height: 20),
            const Text('تم إنشاء الطلب بنجاح!',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
                'يمكنك تتبع الطلب من شاشة "طلباتي"',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF233C),
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('حسناً',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddress(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text('إضافة عنوان جديد',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'عنوان العنوان (المنزل، العمل...)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'العنوان التفصيلي',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF233C),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('✅ تم إضافة العنوان'),
                          backgroundColor: Color(0xFF25D366)),
                    );
                  },
                  child: const Text('حفظ',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
