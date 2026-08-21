import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/custom_search_bar.dart';
import '../../../shared/widgets/category_pill.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../profile/data/addresses_provider.dart';
import '../../shop/data/shop_data.dart';
import '../../shop/models/product.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<int>? onTabChange;

  const HomeScreen({
    super.key,
    this.onTabChange,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerPage = 0;
  Timer? _bannerTimer;
  String _selectedCategoryFilter = '';

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Fresh Organic\nHarvest Sale',
      'subtitle': 'Up to 40% OFF on garden fruits & greens',
      'code': 'Use code: FRESH40',
      'gradient': const [Color(0xFF004678), Color(0xFF1778BD)],
      'badge': 'LIMITED TIME',
      'emoji': '🥑',
    },
    {
      'title': 'Farm Fresh\nDaily Dairy',
      'subtitle': 'Flat ₹50 OFF on whole milk & dairy essentials',
      'code': 'Min order ₹299',
      'gradient': const [Color(0xFF008E5E), Color(0xFF19A777)],
      'badge': 'FARM DIRECT',
      'emoji': '🥛',
    },
    {
      'title': 'Fresh Bakery &\nMorning Delights',
      'subtitle': 'Buy 2 Get 1 FREE on fresh sourdough breads',
      'code': 'Freshly baked at 6 AM',
      'gradient': const [Color(0xFFD97706), Color(0xFFF59E0B)],
      'badge': 'HOT DEAL',
      'emoji': '🥐',
    },
  ];

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _bannerController.hasClients) {
        final nextPage = (_currentBannerPage + 1) % _banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultAddress = context.watch<AddressesProvider>().defaultAddress;
    final flashSaleProducts = ShopData.products.where((p) => p.isFlashSale).toList();

    List<Product> displayProducts = ShopData.products;
    if (_selectedCategoryFilter.isNotEmpty) {
      displayProducts = ShopData.products.where((p) => p.categoryId == _selectedCategoryFilter).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar with Centered Grozzby Logo, Location & Notification Bell
            GrozzbyAppTopBar(
              location: defaultAddress.label.isNotEmpty ? defaultAddress.label : 'New York, 10001',
              onLocationTap: () => context.push('/profile/addresses'),
            ),
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Search Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: CustomSearchBar(
                        readOnly: true,
                        onTap: () => context.push('/search'),
                        onFilterTap: () => context.push('/search'),
                      ),
                    ),
                  ),

            // Delivery Banner (15-min express delivery)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: AppColors.warningForeground, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '⚡ Express 15-Minute Delivery to your doorstep',
                        style: AppTextStyles.labelBold12Inter.copyWith(
                          fontSize: 11,
                          color: AppColors.warningForeground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Active Order Live Tracking Banner (Quick Access to My Order Details)
            SliverToBoxAdapter(
              child: InkWell(
                onTap: () => context.push('/orders/ord_1'),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2563EB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 14),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #AS-882910 is In Transit',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E3A8A),
                                fontFamily: 'Inter',
                              ),
                            ),
                            Text(
                              'Expected Tomorrow, Oct 28 • Tap to View Details',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF3B82F6),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Color(0xFF2563EB)),
                    ],
                  ),
                ),
              ),
            ),

            // Carousel Promotional Banners
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 146,
                    child: PageView.builder(
                      controller: _bannerController,
                      onPageChanged: (idx) => setState(() => _currentBannerPage = idx),
                      itemCount: _banners.length,
                      itemBuilder: (context, index) {
                        final banner = _banners[index];
                        return InkWell(
                          onTap: () => context.push('/search?q=Fresh'),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: banner['gradient'] as List<Color>,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: (banner['gradient'] as List<Color>)[0].withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                bottom: -6,
                                child: Text(
                                  banner['emoji'] as String,
                                  style: const TextStyle(fontSize: 64),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.white.withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      banner['badge'] as String,
                                      style: AppTextStyles.captionBlack10.copyWith(
                                        fontSize: 9,
                                        color: AppColors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    banner['title'] as String,
                                    style: AppTextStyles.headingBold18.copyWith(
                                      color: AppColors.white,
                                      height: 1.15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    banner['subtitle'] as String,
                                    style: AppTextStyles.captionRegular10.copyWith(
                                      color: AppColors.white.withValues(alpha: 0.9),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Banner Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _banners.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentBannerPage == i ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _currentBannerPage == i
                              ? AppColors.primary
                              : AppColors.neutral300,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Categories Header & Horizontal List
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SectionHeader(
                    title: 'Shop by Category',
                    subtitle: 'Fresh produce, dairy & pantry essentials',
                    onActionTap: () {
                      widget.onTabChange?.call(1);
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 96,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: ShopData.categories.length,
                      itemBuilder: (context, index) {
                        final cat = ShopData.categories[index];
                        final isSel = _selectedCategoryFilter == cat.id;
                        return CategoryPill(
                          category: cat,
                          isSelected: isSel,
                          onTap: () {
                            setState(() {
                              _selectedCategoryFilter = isSel ? '' : cat.id;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // Flash Deals / Super Savers Section
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.danger,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.flash_on_rounded, color: AppColors.white, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                'FLASH DEALS',
                                style: AppTextStyles.captionBlack10.copyWith(
                                  color: AppColors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ends in 03h : 24m : 18s',
                          style: AppTextStyles.captionRegular10.copyWith(
                            fontSize: 11,
                            color: AppColors.danger,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => widget.onTabChange?.call(1),
                          child: Text(
                            'See All',
                            style: AppTextStyles.labelBold12Inter.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: flashSaleProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ProductCard(
                            width: 164,
                            product: flashSaleProducts[index],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Popular & Best Sellers Grid
            SliverToBoxAdapter(
              child: SectionHeader(
                title: _selectedCategoryFilter.isEmpty
                    ? 'Best Sellers'
                    : ShopData.categories.firstWhere((c) => c.id == _selectedCategoryFilter).name,
                subtitle: 'Most ordered groceries this week',
                onActionTap: () => widget.onTabChange?.call(1),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductCard(product: displayProducts[index % displayProducts.length]);
                  },
                  childCount: displayProducts.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    ],
  ),
),
);
}
}
