import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';

class StoreLocatorScreen extends StatefulWidget {
  const StoreLocatorScreen({super.key});

  @override
  State<StoreLocatorScreen> createState() => _StoreLocatorScreenState();
}

class _StoreLocatorScreenState extends State<StoreLocatorScreen> {
  int _selectedStoreIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Map<String, dynamic>> _stores = [
    {
      'id': 'soho',
      'name': 'Aura Flagship - Soho',
      'distance': '1.2 miles away',
      'status': 'Open',
      'hours': 'Open until 9:00 PM',
      'address': '452 Broadway, New York, NY 10013',
      'phone': '+1 (212) 555-0199',
      'lat': 40.7209,
      'lng': -73.9998,
      'top': 160.0,
      'left': 90.0,
    },
    {
      'id': 'chelsea',
      'name': 'Aura Chelsea',
      'distance': '2.8 miles away',
      'status': 'Open',
      'hours': 'Open until 8:00 PM',
      'address': '184 9th Ave, New York, NY 10011',
      'phone': '+1 (212) 555-0144',
      'lat': 40.7455,
      'lng': -74.0012,
      'top': 100.0,
      'left': 180.0,
    },
    {
      'id': 'williamsburg',
      'name': 'Aura Williamsburg',
      'distance': '4.5 miles away',
      'status': 'Open',
      'hours': 'Open until 9:00 PM',
      'address': '85 N 3rd St, Brooklyn, NY 11249',
      'phone': '+1 (718) 555-0188',
      'lat': 40.7178,
      'lng': -73.9632,
      'top': 140.0,
      'left': 260.0,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        child: Stack(
          children: [
            // 1. Perspective Map Background Canvas matching screenshot
            Positioned.fill(
              child: Container(
                color: const Color(0xFFE5E7EB),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Vector architectural perspective map
                    Image.network(
                      'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=1200&auto=format&fit=crop&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFEDEEEF),
                        child: const Center(
                          child: Icon(Icons.map_outlined, size: 72, color: Color(0xFF94A3B8)),
                        ),
                      ),
                    ),

                    // Golden Map GPS Pins matching screenshot
                    Positioned(
                      top: 190,
                      left: 70,
                      child: _buildMapPin(
                        index: 0,
                        isPrimary: true,
                        label: '●',
                        onTap: () => setState(() => _selectedStoreIndex = 0),
                      ),
                    ),
                    Positioned(
                      top: 130,
                      left: 150,
                      child: _buildMapPin(
                        index: 1,
                        isPrimary: true,
                        label: '●',
                        onTap: () => setState(() => _selectedStoreIndex = 1),
                      ),
                    ),
                    Positioned(
                      top: 170,
                      left: 240,
                      child: _buildMapPin(
                        index: 2,
                        isPrimary: true,
                        label: '●',
                        onTap: () => setState(() => _selectedStoreIndex = 2),
                      ),
                    ),

                    // Cluster & Landmark Pins (4, 6, 8, 9)
                    Positioned(
                      top: 110,
                      right: 40,
                      child: _buildClusterPin('6'),
                    ),
                    Positioned(
                      top: 150,
                      left: 175,
                      child: _buildClusterPin('8'),
                    ),
                    Positioned(
                      top: 155,
                      left: 205,
                      child: _buildClusterPin('9'),
                    ),
                    Positioned(
                      top: 165,
                      right: 45,
                      child: _buildClusterPin('4'),
                    ),
                    Positioned(
                      top: 210,
                      right: 75,
                      child: _buildClusterPin('8'),
                    ),

                    // Map Zoom & Recenter Controls
                    Positioned(
                      top: 80,
                      right: 16,
                      child: Column(
                        children: [
                          _buildMapControlBtn(Icons.add_rounded, () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Zoomed in')),
                            );
                          }),
                          const SizedBox(height: 8),
                          _buildMapControlBtn(Icons.remove_rounded, () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Zoomed out')),
                            );
                          }),
                          const SizedBox(height: 8),
                          _buildMapControlBtn(Icons.my_location_rounded, () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Centered to current location (Soho)')),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Top Header Bar: "← Find a Store" + Search Icon
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _isSearching
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Search city, state or zip code...',
                                hintStyle: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontFamily: 'Inter'),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, color: Color(0xFF191C1D)),
                            onPressed: () {
                              setState(() {
                                _isSearching = false;
                                _searchController.clear();
                              });
                            },
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/home');
                              }
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: 22,
                                color: Color(0xFF191C1D),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Find a Store',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF191C1D),
                              letterSpacing: -0.3,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.search_rounded,
                              size: 22,
                              color: Color(0xFF191C1D),
                            ),
                            onPressed: () => setState(() => _isSearching = true),
                          ),
                        ],
                      ),
              ),
            ),

            // 3. Draggable Store Sheet matching Node 277:5213 & 277:5093
            DraggableScrollableSheet(
              initialChildSize: 0.38,
              minChildSize: 0.20,
              maxChildSize: 0.94,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                    children: [
                      // Drag Handle Pill
                      Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB9CEEC),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // In-Store Product Stock Context Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD0E1FB).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 14, color: Color(0xFF00288E)),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Fresh Aisles In Stock • Nearest pickup & 15-min delivery',
                                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF00288E), fontFamily: 'Inter'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Header Row: Stores Nearby • 3 Locations Found
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'Stores Nearby',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF191C1D),
                              letterSpacing: -0.3,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            '3 Locations Found',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF505050),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 3 Store Cards
                      ...List.generate(_stores.length, (idx) {
                        final store = _stores[idx];
                        final isSelected = _selectedStoreIndex == idx;
                        final stockUnits = idx == 0 ? '42 in stock' : (idx == 1 ? '18 in stock' : '9 in stock');

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCBDAEF),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF00288E) : const Color(0xFFB9CEEC),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row: Name + Open Badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      store['name'] as String,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF191C1D),
                                        letterSpacing: -0.2,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: const Text(
                                      'Open',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF006C4B),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              // Distance & In-Stock Row
                              Row(
                                children: [
                                  const Icon(Icons.near_me_outlined, size: 14, color: Color(0xFF505050)),
                                  const SizedBox(width: 4),
                                  Text(
                                    store['distance'] as String,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFF505050),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('•', style: TextStyle(color: Color(0xFF94A3B8))),
                                  const SizedBox(width: 8),
                                  Text(
                                    stockUnits,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF006C4B),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Hours Row with Clock icon
                              Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF505050)),
                                  const SizedBox(width: 6),
                                  Text(
                                    store['hours'] as String,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFF505050),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Primary CTA: Directions Button
                              SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Starting GPS route to ${store['name']}...'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00288E),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Directions',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Secondary CTA: Store Details Text Button
                              Center(
                                child: TextButton(
                                  onPressed: () => context.push('/stores/${store['id']}'),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  ),
                                  child: const Text(
                                    'Store Details',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF191C1D),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPin({
    required int index,
    required bool isPrimary,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFFBBF24),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.location_on_rounded,
            size: 20,
            color: Color(0xFF191C1D),
          ),
        ),
      ),
    );
  }

  Widget _buildClusterPin(String count) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.85),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          count,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildMapControlBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, size: 18, color: const Color(0xFF191C1D)),
        ),
      ),
    );
  }
}
