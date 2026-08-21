import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';

class ShippingPreferencesScreen extends StatefulWidget {
  const ShippingPreferencesScreen({super.key});

  @override
  State<ShippingPreferencesScreen> createState() => _ShippingPreferencesScreenState();
}

class _ShippingPreferencesScreenState extends State<ShippingPreferencesScreen> {
  int _selectedAddressIndex = 0;
  String _selectedSlot = 'afternoon'; // 'morning', 'afternoon', 'evening'
  String _selectedShippingMethod = 'standard'; // 'standard', 'express'

  final List<Map<String, dynamic>> _addresses = [
    {
      'label': 'Home',
      'isDefault': true,
      'street': '742 Evergreen Terrace',
      'cityStateZip': 'Springfield, IL 62704',
      'country': 'United States',
    },
    {
      'label': 'Office',
      'isDefault': false,
      'street': '1200 Industrial Way, Suite 402',
      'cityStateZip': 'Springfield, IL 62701',
      'country': 'United States',
    },
  ];

  void _showAddAddressDialog() {
    final labelCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final cityStateZipCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF191C1D),
                      fontFamily: 'Inter',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: labelCtrl,
                decoration: InputDecoration(
                  labelText: 'Address Label (e.g. Vacation Home, Studio)',
                  labelStyle: const TextStyle(fontSize: 13, fontFamily: 'Inter'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: streetCtrl,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  labelStyle: const TextStyle(fontSize: 13, fontFamily: 'Inter'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityStateZipCtrl,
                decoration: InputDecoration(
                  labelText: 'City, State Zip (e.g. New York, NY 10001)',
                  labelStyle: const TextStyle(fontSize: 13, fontFamily: 'Inter'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (streetCtrl.text.trim().isNotEmpty) {
                      setState(() {
                        _addresses.add({
                          'label': labelCtrl.text.trim().isNotEmpty ? labelCtrl.text.trim() : 'Other',
                          'isDefault': false,
                          'street': streetCtrl.text.trim(),
                          'cityStateZip': cityStateZipCtrl.text.trim().isNotEmpty ? cityStateZipCtrl.text.trim() : 'Springfield, IL 62704',
                          'country': 'United States',
                        });
                        _selectedAddressIndex = _addresses.length - 1;
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('New delivery address added successfully!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00288E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Save Address',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: GrozzbyBottomNavBar(
        currentIndex: 4, // Profile tab
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
            // 1. Top Header Bar: "← Shipping Preferences"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        context.go('/profile');
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
                    'Shipping Preferences',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191C1D),
                      letterSpacing: -0.3,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content matching uploaded Figma screenshot exactly
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Default Delivery Address
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Default Delivery Address',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF191C1D),
                            letterSpacing: -0.2,
                            fontFamily: 'Inter',
                          ),
                        ),
                        InkWell(
                          onTap: _showAddAddressDialog,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                            child: Text(
                              'Add New',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF00288E),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Address Cards Loop
                    ...List.generate(_addresses.length, (idx) {
                      final addr = _addresses[idx];
                      final isSelected = _selectedAddressIndex == idx;

                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedAddressIndex = idx);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF00288E) : const Color(0xFFE2E8F0),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? const Color(0xFF00288E).withValues(alpha: 0.05)
                                    : Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    addr['label'] as String,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF191C1D),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00288E),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'DEFAULT',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 0.6,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                  const Spacer(),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Color(0xFF00288E),
                                      size: 20,
                                    )
                                  else
                                    const Icon(
                                      Icons.radio_button_unchecked_rounded,
                                      color: Color(0xFFCBD5E1),
                                      size: 20,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                addr['street'] as String,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFF505050),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                addr['cityStateZip'] as String,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFF505050),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                addr['country'] as String,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFF505050),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Section 2: Preferred Delivery Slot
                    const Text(
                      'Preferred Delivery Slot',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF191C1D),
                        letterSpacing: -0.2,
                        fontFamily: 'Inter',
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 3 Delivery Slot Cards (Morning, Afternoon, Evening)
                    _buildSlotCard(
                      id: 'morning',
                      title: 'Morning',
                      time: '8AM - 12PM',
                      icon: Icons.wb_twilight_rounded,
                    ),
                    const SizedBox(height: 10),
                    _buildSlotCard(
                      id: 'afternoon',
                      title: 'Afternoon',
                      time: '12PM - 5PM',
                      icon: Icons.wb_sunny_rounded,
                    ),
                    const SizedBox(height: 10),
                    _buildSlotCard(
                      id: 'evening',
                      title: 'Evening',
                      time: '5PM - 9PM',
                      icon: Icons.bedtime_outlined,
                    ),

                    const SizedBox(height: 24),

                    // Section 3: Default Shipping Method
                    const Text(
                      'Default Shipping Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF191C1D),
                        letterSpacing: -0.2,
                        fontFamily: 'Inter',
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Method 1: Standard Shipping
                    _buildShippingMethodCard(
                      id: 'standard',
                      title: 'Standard Shipping',
                      subtitle: '3-5 Business Days • Free',
                      icon: Icons.local_shipping_outlined,
                      isBlueIcon: true,
                    ),
                    const SizedBox(height: 10),

                    // Method 2: Express Delivery
                    _buildShippingMethodCard(
                      id: 'express',
                      title: 'Express Delivery',
                      subtitle: 'Next Day • \$12.99',
                      icon: Icons.bolt_rounded,
                      isBlueIcon: false,
                    ),

                    const SizedBox(height: 32),

                    // Primary Button: Update Preferences
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Shipping preferences updated successfully!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          context.pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00288E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Update Preferences',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Footer Italic Note
                    const Center(
                      child: Text(
                        'Changes will be applied to your next checkout.',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF505050),
                          fontFamily: 'Inter',
                        ),
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

  Widget _buildSlotCard({
    required String id,
    required String title,
    required String time,
    required IconData icon,
  }) {
    final isSelected = _selectedSlot == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedSlot = id),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00288E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF00288E) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF00288E).withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : const Color(0xFF191C1D),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF191C1D),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: TextStyle(
                fontSize: 11.5,
                color: isSelected ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF64748B),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingMethodCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isBlueIcon,
  }) {
    final isSelected = _selectedShippingMethod == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedShippingMethod = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF00288E) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF00288E).withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isBlueIcon ? const Color(0xFFD0E1FB) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isBlueIcon ? const Color(0xFF00288E) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191C1D),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF505050),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF00288E),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.circle, color: Colors.white, size: 8),
                ),
              )
            else
              const Icon(
                Icons.radio_button_unchecked_rounded,
                color: Color(0xFFCBD5E1),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
