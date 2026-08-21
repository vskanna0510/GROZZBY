import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/grozzby_logo.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';

class StoreDetailsScreen extends StatefulWidget {
  final String? storeId;

  const StoreDetailsScreen({super.key, this.storeId});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  final List<Map<String, dynamic>> _amenities = [
    {'name': 'Free Wi-Fi', 'icon': Icons.wifi_rounded},
    {'name': 'Aura Cafe', 'icon': Icons.local_cafe_outlined},
    {'name': 'Repair Center', 'icon': Icons.build_outlined},
    {'name': 'Valet', 'icon': Icons.directions_car_outlined},
    {'name': 'Click & Collect', 'icon': Icons.shopping_bag_outlined},
    {'name': 'Wheelchair Access', 'icon': Icons.accessible_rounded},
  ];

  final List<Map<String, dynamic>> _hours = [
    {'day': 'Monday', 'time': '10:00 AM - 9:00 PM', 'isToday': false},
    {'day': 'Tuesday', 'time': '10:00 AM - 9:00 PM', 'isToday': true},
    {'day': 'Wednesday', 'time': '10:00 AM - 9:00 PM', 'isToday': false},
    {'day': 'Thursday', 'time': '10:00 AM - 9:00 PM', 'isToday': false},
    {'day': 'Friday', 'time': '10:00 AM - 10:00 PM', 'isToday': false},
    {'day': 'Saturday', 'time': '10:00 AM - 10:00 PM', 'isToday': false},
    {'day': 'Sunday', 'time': '11:00 AM - 7:00 PM', 'isToday': false},
  ];

  void _showBookingDialog() {
    String selectedDate = 'Today, 4:00 PM';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD0E1FB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.event_available_rounded, color: Color(0xFF00288E)),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Shopping',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF191C1D), fontFamily: 'Inter'),
                            ),
                            Text(
                              'Soho Flagship Store',
                              style: TextStyle(fontSize: 12.5, color: Color(0xFF505050), fontFamily: 'Inter'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  const Text(
                    'Select Session Time',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF191C1D), fontFamily: 'Inter'),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Today, 4:00 PM',
                      'Today, 5:30 PM',
                      'Tomorrow, 11:00 AM',
                      'Tomorrow, 2:00 PM',
                    ].map((time) {
                      final isSel = selectedDate == time;
                      return ChoiceChip(
                        label: Text(time),
                        selected: isSel,
                        selectedColor: const Color(0xFF00288E),
                        backgroundColor: const Color(0xFFF1F5F9),
                        labelStyle: TextStyle(
                          color: isSel ? Colors.white : const Color(0xFF191C1D),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide.none,
                        onSelected: (val) {
                          if (val) setModalState(() => selectedDate = time);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Appointment confirmed for $selectedDate with an Aura Stylist!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00288E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Confirm Appointment',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: GrozzbyBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/categories');
              break;
            case 2:
              context.go('/search');
              break;
            case 3:
              context.go('/cart');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top App Bar matching Figma & Screenshot (Back arrow, Grozzby logo, Bag icon)
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/stores');
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.arrow_back_rounded, size: 22, color: Color(0xFF191C1D)),
                    ),
                  ),
                  const Spacer(),
                  const GrozzbyLogo(height: 26),
                  const Spacer(),
                  InkWell(
                    onTap: () => context.push('/cart'),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.shopping_bag_outlined, size: 22, color: Color(0xFF191C1D)),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Hero Image Section matching architectural storefront
                    Stack(
                      children: [
                        SizedBox(
                          height: 320,
                          width: double.infinity,
                          child: Image.network(
                            'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?w=1200&auto=format&fit=crop&q=80',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: const Color(0xFF191C1D),
                              child: const Center(
                                child: Icon(Icons.storefront_rounded, size: 64, color: Colors.white38),
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.2),
                                  Colors.black.withValues(alpha: 0.6),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 3. Floating Store Header Card (White Card)
                    Transform.translate(
                      offset: const Offset(0, -32),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Aura Flagship - Soho',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF191C1D),
                                  letterSpacing: -0.4,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: const [
                                  Icon(Icons.near_me_outlined, size: 14, color: Color(0xFF505050)),
                                  SizedBox(width: 4),
                                  Text(
                                    '1.2 miles',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF505050),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('•', style: TextStyle(color: Color(0xFF94A3B8))),
                                  SizedBox(width: 8),
                                  Text(
                                    'Open · Closes at 9:00 PM',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF006C4B),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // 4 Action Buttons: Call, Directions, Share, Website
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildActionButton(
                                    icon: Icons.phone_outlined,
                                    label: 'Call',
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Calling Aura Soho at +1 (212) 555-0198...')),
                                      );
                                    },
                                  ),
                                  _buildActionButton(
                                    icon: Icons.navigation_outlined,
                                    label: 'Directions',
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Opening GPS turn-by-turn navigation...')),
                                      );
                                    },
                                  ),
                                  _buildActionButton(
                                    icon: Icons.share_outlined,
                                    label: 'Share',
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Store address copied to clipboard!')),
                                      );
                                    },
                                  ),
                                  _buildActionButton(
                                    icon: Icons.language_rounded,
                                    label: 'Website',
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Opening Aura Soho official portal...')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 4. Exclusive Services: Personal Shopping (Soft Blue Card)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD0E1FB),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.event_note_rounded, size: 16, color: Color(0xFF00288E)),
                                SizedBox(width: 8),
                                Text(
                                  'EXCLUSIVE SERVICES',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF00288E),
                                    letterSpacing: 0.8,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Personal Shopping',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF191C1D),
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Dedicated one-on-one time with our experts to find exactly what you need.',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF504533),
                                height: 1.45,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _showBookingDialog,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00288E),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Book Appointment',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 5. Amenities Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Amenities',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF191C1D),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 96,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _amenities.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 12),
                              itemBuilder: (ctx, idx) {
                                final item = _amenities[idx];
                                return Container(
                                  width: 88,
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFE5E7EB)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.03),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(item['icon'] as IconData, size: 24, color: const Color(0xFF191C1D)),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['name'] as String,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF191C1D),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Fresh In-Store Aisles / Products from this Store
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Fresh In-Store Aisles',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF191C1D),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              InkWell(
                                onTap: () => context.go('/categories'),
                                child: const Row(
                                  children: [
                                    Text(
                                      'View all',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF00288E),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF00288E)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Dispatched fresh daily from Aura Flagship Soho aisles',
                            style: TextStyle(fontSize: 12.5, color: Color(0xFF505050), fontFamily: 'Inter'),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 220,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildInStoreProductCard(
                                  id: 'prod_1',
                                  name: 'Royal Gala Apples',
                                  price: '₹180',
                                  unit: '1 kg',
                                  imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&auto=format&fit=crop&q=80',
                                  stock: '42 in stock',
                                ),
                                const SizedBox(width: 14),
                                _buildInStoreProductCard(
                                  id: 'prod_2',
                                  name: 'Farm Fresh Whole Milk',
                                  price: '₹65',
                                  unit: '1 L',
                                  imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&auto=format&fit=crop&q=80',
                                  stock: '28 in stock',
                                ),
                                const SizedBox(width: 14),
                                _buildInStoreProductCard(
                                  id: 'prod_3',
                                  name: 'Artisanal Sourdough Bread',
                                  price: '₹95',
                                  unit: '400g',
                                  imageUrl: 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?w=400&auto=format&fit=crop&q=80',
                                  stock: '15 in stock',
                                ),
                                const SizedBox(width: 14),
                                _buildInStoreProductCard(
                                  id: 'prod_4',
                                  name: 'Hass Avocados (2 pcs)',
                                  price: '₹240',
                                  unit: '2 pcs',
                                  imageUrl: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400&auto=format&fit=crop&q=80',
                                  stock: '30 in stock',
                                ),
                                const SizedBox(width: 14),
                                _buildInStoreProductCard(
                                  id: 'prod_5',
                                  name: 'Fresh Organic Strawberries',
                                  price: '₹160',
                                  unit: '250g',
                                  imageUrl: 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400&auto=format&fit=crop&q=80',
                                  stock: '19 in stock',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 6. Address & Phone Card (White Card)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, color: Color(0xFF505050), size: 22),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '123 Prince Street, Soho',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF191C1D),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'New York, NY 10012',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF505050),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(height: 24, color: Color(0xFFF1F5F9)),
                            Row(
                              children: [
                                const Icon(Icons.phone_outlined, color: Color(0xFF505050), size: 22),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '+1 (212) 555-0198',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF191C1D),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Store Line',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF505050),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // 7. Store Hours Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Store Hours',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF191C1D),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: _hours.map((h) {
                                final isToday = h['isToday'] as bool;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        h['day'] as String,
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                          color: const Color(0xFF191C1D),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            h['time'] as String,
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                              color: const Color(0xFF505050),
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                          if (isToday) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF006C4B),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, size: 20, color: const Color(0xFF191C1D)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF505050),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInStoreProductCard({
    required String id,
    required String name,
    required String price,
    required String unit,
    required String imageUrl,
    required String stock,
  }) {
    return InkWell(
      onTap: () => context.push('/product/$id'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF8FAFC),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.shopping_bag_outlined,
                    size: 32,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Product Name
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF191C1D),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 2),
            // Unit & Stock
            Text(
              '$unit • $stock',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF006C4B),
                fontFamily: 'Inter',
              ),
            ),
            const Spacer(),
            // Price + Add Button Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF00288E),
                    fontFamily: 'Inter',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00288E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '+ Add',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
