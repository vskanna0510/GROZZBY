import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'orders',
      'title': 'Orders',
      'icon': Icons.inventory_2_outlined,
      'color': const Color(0xFFD97706),
      'bgColor': const Color(0xFFFEF3C7),
    },
    {
      'id': 'shipping',
      'title': 'Shipping',
      'icon': Icons.local_shipping_outlined,
      'color': const Color(0xFF10B981),
      'bgColor': const Color(0xFFD1FAE5),
    },
    {
      'id': 'payments',
      'title': 'Payments',
      'icon': Icons.credit_card_rounded,
      'color': const Color(0xFF3B82F6),
      'bgColor': const Color(0xFFDBEAFE),
    },
    {
      'id': 'returns',
      'title': 'Returns',
      'icon': Icons.replay_rounded,
      'color': const Color(0xFFEC4899),
      'bgColor': const Color(0xFFFCE7F3),
    },
    {
      'id': 'account',
      'title': 'Account',
      'icon': Icons.person_outline_rounded,
      'color': const Color(0xFFD97706),
      'bgColor': const Color(0xFFFEF3C7),
      'isFullWidth': true,
    },
  ];

  final List<Map<String, String>> _articles = [
    {
      'id': '1',
      'category': 'orders',
      'title': 'How to track your order status',
      'subtitle': 'Step-by-step guide to tracking your shipment from warehouse to doorstep.',
      'content': 'You can track your order in real-time from the "My Orders" tab. Tap on your active order and click "Live Tracking" to view a real-time GPS map with your delivery rider\'s live location, distance remaining, and estimated delivery time.',
    },
    {
      'id': '2',
      'category': 'returns',
      'title': 'Return policy and refunds',
      'subtitle': 'Everything you need to know about our 30-day return policy and refund timing.',
      'content': 'We offer a 100% satisfaction guarantee on all groceries and fresh produce. If any item is damaged, missing, or below quality expectations, you can request an instant replacement or full refund directly from the order details screen within 30 days.',
    },
    {
      'id': '3',
      'category': 'shipping',
      'title': 'Updating your shipping address',
      'subtitle': 'Modified your address after placing an order? Learn how to update it quickly.',
      'content': 'To change your delivery address for an in-flight order, open the order and tap "Contact Concierge" or use Live Chat within 5 minutes of placing your order. You can also manage your permanent saved addresses in Profile > Shipping Preferences.',
    },
    {
      'id': '4',
      'category': 'account',
      'title': 'Managing Aura Rewards points',
      'subtitle': 'Redeem your points for exclusive discounts and early access to sales.',
      'content': 'You earn 5 Grozzby Reward points for every ₹100 spent. Points can be applied at checkout for instant cash discounts on your cart total, or redeemed for free express delivery perks.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredArticles = _articles.where((article) {
      final matchesQuery = _searchQuery.isEmpty ||
          article['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          article['subtitle']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = _selectedCategory == null || article['category'] == _selectedCategory;
      return matchesQuery && matchesCat;
    }).toList();

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
            // Top App Bar with location, brand logo and notifications
            const GrozzbyAppTopBar(),

            // Header Navigation (Back button, Title)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    'Help Center',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191C1D),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Main Content matching Figma Node 277:4558
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Hero Search Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'How can we help?',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF191C1D),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Search for articles or browse categories below',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF505050),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Rounded Pill Search Input
                          Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(9999),
                              border: Border.all(color: const Color(0xFF505050), width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                const Icon(Icons.search_rounded, size: 20, color: Color(0xFF505050)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (val) => setState(() => _searchQuery = val),
                                    decoration: const InputDecoration(
                                      hintText: 'Search for orders, returns, and more...',
                                      hintStyle: TextStyle(
                                        fontSize: 13,
                                        color: Color(0x99505050),
                                        fontFamily: 'Inter',
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF64748B)),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 2. Category Bento Grid (2x2 + 1 Full Width)
                    Column(
                      children: [
                        // Row 1: Orders & Shipping
                        Row(
                          children: [
                            Expanded(child: _buildCategoryCard(_categories[0])),
                            const SizedBox(width: 12),
                            Expanded(child: _buildCategoryCard(_categories[1])),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Row 2: Payments & Returns
                        Row(
                          children: [
                            Expanded(child: _buildCategoryCard(_categories[2])),
                            const SizedBox(width: 12),
                            Expanded(child: _buildCategoryCard(_categories[3])),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Row 3: Account (Full Width)
                        _buildCategoryCard(_categories[4], isFullWidth: true),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // 3. Section - Popular Articles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Popular Articles',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF191C1D),
                            letterSpacing: -0.3,
                            fontFamily: 'Inter',
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategory = null;
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                          child: const Row(
                            children: [
                              Text(
                                'View all',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF505050),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF505050)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Articles List
                    ...filteredArticles.map((article) {
                      final isLast = article['id'] == '4';
                      final iconBg = isLast ? const Color(0xFFE7E8E9) : const Color(0xFFD2DCFF);
                      final iconColor = isLast ? const Color(0xFF505050) : const Color(0xFF1E40AF);

                      return InkWell(
                        onTap: () => _showArticleModal(context, article),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: iconBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.article_outlined,
                                    size: 22,
                                    color: iconColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['title']!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF191C1D),
                                        height: 1.3,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      article['subtitle']!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF505050),
                                        height: 1.45,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 32),

                    // 4. Section - Still need help? Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0E1FB),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Still need help?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF261900),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Our support team is available 24/7 to assist you with any questions or concerns you might have about your Aura experience.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF505050),
                              height: 1.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Live Chat Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () => context.push('/support/chat'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00288E),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.chat_bubble_outline_rounded, size: 20, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Live Chat',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Email Us Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton(
                              onPressed: () => context.push('/support/contact'),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF261900),
                                side: const BorderSide(color: Color(0x33261900), width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.mail_outline_rounded, size: 20, color: Color(0xFF261900)),
                                  SizedBox(width: 8),
                                  Text(
                                    'Email Us',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
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

  Widget _buildCategoryCard(Map<String, dynamic> cat, {bool isFullWidth = false}) {
    final isSelected = _selectedCategory == cat['id'];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCategory = isSelected ? null : cat['id'];
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: isFullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF00288E) : const Color(0x4DD4C4AD),
              width: isSelected ? 2 : 1,
            ),
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
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: cat['bgColor'] as Color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    cat['icon'] as IconData,
                    size: 24,
                    color: cat['color'] as Color,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                cat['title'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF191C1D),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showArticleModal(BuildContext context, Map<String, String> article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                article['title']!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF191C1D),
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article['subtitle']!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                  fontFamily: 'Inter',
                ),
              ),
              const Divider(height: 32),
              Text(
                article['content']!,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.6,
                  color: Color(0xFF334155),
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/support/faq');
                  },
                  icon: const Icon(Icons.help_outline_rounded, size: 16, color: Color(0xFF00288E)),
                  label: const Text('View Full Orders & Shipping FAQ →', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF00288E),
                    side: const BorderSide(color: Color(0xFF00288E)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Was this article helpful?',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.thumb_up_alt_outlined, size: 18, color: Color(0xFF10B981)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Thank you for your feedback!')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.thumb_down_alt_outlined, size: 18, color: Color(0xFFEF4444)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Feedback recorded. We will improve this guide.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
