import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';
import '../../../shared/widgets/product_card.dart';
import '../../shop/data/shop_data.dart';
import '../../shop/models/product.dart';

class CategoryCatalogScreen extends StatefulWidget {
  final String? initialCategoryId;
  final bool showBottomNav;

  const CategoryCatalogScreen({
    super.key,
    this.initialCategoryId,
    this.showBottomNav = true,
  });

  @override
  State<CategoryCatalogScreen> createState() => _CategoryCatalogScreenState();
}

class _CategoryCatalogScreenState extends State<CategoryCatalogScreen> {
  late String _selectedCategoryId;
  String _activeFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Advanced Filter state
  double _maxPriceFilter = 1000;
  bool _onlyOrganic = false;
  bool _onlyOnSale = false;
  double? _minRating;
  String _sortBy = 'Recommended'; // 'Recommended', 'Price: Low-High', 'Price: High-Low', 'Rating'

  final List<String> _quickFilterOptions = [
    'All',
    'Popular',
    'On Sale',
    'Organic',
    'Under ₹100',
    'Price: Low-High',
    'Price: High-Low',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId ?? ShopData.categories.first.id;
  }

  @override
  void didUpdateWidget(covariant CategoryCatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategoryId != null && widget.initialCategoryId != oldWidget.initialCategoryId) {
      setState(() {
        _selectedCategoryId = widget.initialCategoryId!;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterModal(BuildContext context) {
    double tempMaxPrice = _maxPriceFilter;
    bool tempOrganic = _onlyOrganic;
    bool tempOnSale = _onlyOnSale;
    double? tempRating = _minRating;
    String tempSort = _sortBy;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Modal Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.tune_rounded, size: 20, color: Color(0xFF2563EB)),
                            SizedBox(width: 8),
                            Text(
                              'Filter & Sort Category',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),

                  // Modal Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Sort By Section
                          const Text(
                            'Sort By',
                            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ['Recommended', 'Price: Low-High', 'Price: High-Low', 'Rating'].map((sort) {
                              final isSel = tempSort == sort;
                              return ChoiceChip(
                                label: Text(sort),
                                selected: isSel,
                                onSelected: (sel) {
                                  if (sel) setModalState(() => tempSort = sort);
                                },
                                selectedColor: const Color(0xFFEFF6FF),
                                backgroundColor: const Color(0xFFF8FAFC),
                                side: BorderSide(
                                  color: isSel ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                  width: isSel ? 1.5 : 1,
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                labelStyle: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                                  color: isSel ? const Color(0xFF2563EB) : const Color(0xFF475569),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 22),

                          // 2. Max Price Filter
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Price Range',
                                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                              ),
                              Text(
                                'Up to ₹${tempMaxPrice.toInt()}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                              ),
                            ],
                          ),
                          Slider(
                            value: tempMaxPrice,
                            min: 50,
                            max: 1000,
                            divisions: 19,
                            activeColor: const Color(0xFF2563EB),
                            inactiveColor: const Color(0xFFE2E8F0),
                            onChanged: (val) => setModalState(() => tempMaxPrice = val),
                          ),

                          const SizedBox(height: 18),

                          // 3. Quick Toggles
                          const Text(
                            'Preferences & Offers',
                            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 10),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Organic Products Only 🌿', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                            value: tempOrganic,
                            activeThumbColor: const Color(0xFF16A34A),
                            onChanged: (val) => setModalState(() => tempOrganic = val),
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('On Sale / Discounted 🏷️', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                            value: tempOnSale,
                            activeThumbColor: const Color(0xFF2563EB),
                            onChanged: (val) => setModalState(() => tempOnSale = val),
                          ),

                          const SizedBox(height: 18),

                          // 4. Rating Filter
                          const Text(
                            'Customer Rating',
                            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _buildRatingChip('Any', null, tempRating == null, () => setModalState(() => tempRating = null)),
                              const SizedBox(width: 8),
                              _buildRatingChip('4.5+ ★', 4.5, tempRating == 4.5, () => setModalState(() => tempRating = 4.5)),
                              const SizedBox(width: 8),
                              _buildRatingChip('4.8+ ★', 4.8, tempRating == 4.8, () => setModalState(() => tempRating = 4.8)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Action Buttons
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                tempMaxPrice = 1000;
                                tempOrganic = false;
                                tempOnSale = false;
                                tempRating = null;
                                tempSort = 'Recommended';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Reset All', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _maxPriceFilter = tempMaxPrice;
                                _onlyOrganic = tempOrganic;
                                _onlyOnSale = tempOnSale;
                                _minRating = tempRating;
                                _sortBy = tempSort;
                                _activeFilter = 'Custom';
                              });
                              Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRatingChip(String label, double? value, bool isSel, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSel ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
            color: isSel ? const Color(0xFF2563EB) : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ShopData.categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => ShopData.categories.first,
    );

    // 1. Filter by category
    List<Product> categoryProducts =
        ShopData.products.where((p) => p.categoryId == _selectedCategoryId).toList();

    // 2. Filter by search query in real-time
    if (_searchQuery.isNotEmpty) {
      final queryLower = _searchQuery.toLowerCase();
      categoryProducts = categoryProducts.where((p) {
        return p.name.toLowerCase().contains(queryLower) ||
            p.description.toLowerCase().contains(queryLower) ||
            (p.tag ?? '').toLowerCase().contains(queryLower);
      }).toList();
    }

    // 3. Filter by quick filter options
    if (_activeFilter == 'Popular') {
      categoryProducts = categoryProducts.where((p) => p.rating >= 4.7).toList();
    } else if (_activeFilter == 'On Sale') {
      categoryProducts = categoryProducts
          .where((p) => (p.originalPrice != null && p.originalPrice! > p.price) || p.discountPercent > 0)
          .toList();
    } else if (_activeFilter == 'Organic') {
      categoryProducts = categoryProducts.where((p) {
        final name = p.name.toLowerCase();
        final desc = p.description.toLowerCase();
        final tag = (p.tag ?? '').toLowerCase();
        return name.contains('organic') || desc.contains('organic') || tag.contains('organic') || p.categoryId == 'cat_organic';
      }).toList();
    } else if (_activeFilter == 'Under ₹100') {
      categoryProducts = categoryProducts.where((p) => p.price <= 100).toList();
    } else if (_activeFilter == 'Price: Low-High') {
      categoryProducts = List.from(categoryProducts)..sort((a, b) => a.price.compareTo(b.price));
    } else if (_activeFilter == 'Price: High-Low') {
      categoryProducts = List.from(categoryProducts)..sort((a, b) => b.price.compareTo(a.price));
    } else if (_activeFilter == 'Custom') {
      // Apply advanced modal filters
      categoryProducts = categoryProducts.where((p) => p.price <= _maxPriceFilter).toList();
      if (_onlyOrganic) {
        categoryProducts = categoryProducts.where((p) {
          final name = p.name.toLowerCase();
          final desc = p.description.toLowerCase();
          final tag = (p.tag ?? '').toLowerCase();
          return name.contains('organic') || desc.contains('organic') || tag.contains('organic') || p.categoryId == 'cat_organic';
        }).toList();
      }
      if (_onlyOnSale) {
        categoryProducts = categoryProducts
            .where((p) => (p.originalPrice != null && p.originalPrice! > p.price) || p.discountPercent > 0)
            .toList();
      }
      if (_minRating != null) {
        categoryProducts = categoryProducts.where((p) => p.rating >= _minRating!).toList();
      }
      if (_sortBy == 'Price: Low-High') {
        categoryProducts.sort((a, b) => a.price.compareTo(b.price));
      } else if (_sortBy == 'Price: High-Low') {
        categoryProducts.sort((a, b) => b.price.compareTo(a.price));
      } else if (_sortBy == 'Rating') {
        categoryProducts.sort((a, b) => b.rating.compareTo(a.rating));
      }
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
      bottomNavigationBar: widget.showBottomNav
          ? GrozzbyBottomNavBar(
              currentIndex: 1,
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
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Shared Brand Top Bar
            const GrozzbyAppTopBar(),

            // 2. Interactive In-Category Search & Filter Bar (Does NOT navigate to general search)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              color: AppColors.white,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, size: 18, color: Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim();
                          });
                        },
                        style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontFamily: 'Inter'),
                        decoration: InputDecoration(
                          hintText: 'Search within ${selectedCategory.name}...',
                          hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8), fontFamily: 'Inter'),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      InkWell(
                        onTap: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.clear_rounded, size: 16, color: Color(0xFF94A3B8)),
                        ),
                      ),
                    // Dedicated Filter Icon Button -> Opens In-Page Category Filter Modal
                    InkWell(
                      onTap: () => _openFilterModal(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: _activeFilter == 'Custom' ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          size: 16,
                          color: _activeFilter == 'Custom' ? Colors.white : const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Category Workspace (Left Rail + Right Products Catalog)
            Expanded(
              child: Row(
                children: [
                  // Left Vertical Sidebar Categories
                  Container(
                    width: 90,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      border: Border(
                        right: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                      ),
                    ),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: ShopData.categories.length,
                      itemBuilder: (context, index) {
                        final cat = ShopData.categories[index];
                        final isSelected = cat.id == _selectedCategoryId;
                        final count = ShopData.products.where((p) => p.categoryId == cat.id).length;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategoryId = cat.id;
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFEFF6FF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: cat.backgroundColor,
                                    shape: BoxShape.circle,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      cat.icon,
                                      style: const TextStyle(fontSize: 19),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  cat.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                    color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFF475569),
                                    fontFamily: 'Inter',
                                    height: 1.15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$count items',
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Right Main Catalog Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Banner Header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                          color: AppColors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    selectedCategory.icon,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedCategory.name,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF0F172A),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        Text(
                                          '${categoryProducts.length} items available',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF64748B),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Neatly Arranged Modern Quick Filter Chips
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: _quickFilterOptions.map((filter) {
                                    final isChipSel = _activeFilter == filter;

                                    return Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _activeFilter = filter;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 150),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isChipSel ? const Color(0xFF1E3A8A) : const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: isChipSel ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
                                              width: 1,
                                            ),
                                            boxShadow: isChipSel
                                                ? [
                                                    BoxShadow(
                                                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
                                                      blurRadius: 4,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (isChipSel) ...[
                                                const Icon(Icons.check_rounded, size: 13, color: Colors.white),
                                                const SizedBox(width: 4),
                                              ],
                                              Text(
                                                filter,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: isChipSel ? FontWeight.w800 : FontWeight.w600,
                                                  color: isChipSel ? Colors.white : const Color(0xFF334155),
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(height: 1, color: Color(0xFFE2E8F0)),

                        // Products Grid or Empty State
                        Expanded(
                          child: categoryProducts.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFEFF6FF),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.filter_list_off_rounded, size: 28, color: Color(0xFF2563EB)),
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          _searchQuery.isNotEmpty
                                              ? 'No items matching "$_searchQuery"'
                                              : 'No items found in "$_activeFilter"',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF0F172A),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Try adjusting your search or resetting filters',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: Color(0xFF64748B),
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _searchQuery = '';
                                              _activeFilter = 'All';
                                              _maxPriceFilter = 1000;
                                              _onlyOrganic = false;
                                              _onlyOnSale = false;
                                              _minRating = null;
                                              _sortBy = 'Recommended';
                                            });
                                          },
                                          icon: const Icon(Icons.refresh_rounded, size: 14, color: Colors.white),
                                          label: const Text('Reset All Filters'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF2563EB),
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, fontFamily: 'Inter'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(10),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.60,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                                  itemCount: categoryProducts.length,
                                  itemBuilder: (context, index) {
                                    return ProductCard(product: categoryProducts[index]);
                                  },
                                ),
                        ),
                      ],
                    ),
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
