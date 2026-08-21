import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';
import '../../cart/data/cart_provider.dart';
import '../../shop/data/shop_data.dart';
import '../../shop/models/product.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  final bool showBottomNav;

  const SearchScreen({
    super.key,
    this.initialQuery,
    this.showBottomNav = false,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = ['Running Shoes', 'Tech Gear', 'Silk Scarf'];
  final List<String> _trendingSearches = ['iPhone 15', 'AirPods Max', 'Nike Shoes'];
  String _query = '';
  
  // Filter states
  String _selectedCategory = 'All Items';
  RangeValues _priceRange = const RangeValues(0, 1200);
  final Set<String> _selectedBrands = {'Aura Signature'};
  String? _selectedRating = '4.0+';
  bool _onlyInStock = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _query = widget.initialQuery!;
      _searchController.text = widget.initialQuery!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    setState(() {
      _query = value.trim();
    });
    if (_query.isNotEmpty && !_recentSearches.contains(_query)) {
      setState(() {
        _recentSearches.insert(0, _query);
        if (_recentSearches.length > 6) _recentSearches.removeLast();
      });
    }
  }

  void _openAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Modal Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Advanced Filters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            fontFamily: 'Inter',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),

                  // Filter Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Category Section
                          const Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ['All Items', 'Lighting', 'Furniture', 'Accessories', 'Textiles'].map((cat) {
                              final isSel = _selectedCategory == cat;
                              return ChoiceChip(
                                label: Text(cat),
                                selected: isSel,
                                onSelected: (sel) {
                                  if (sel) {
                                    setModalState(() => _selectedCategory = cat);
                                    setState(() => _selectedCategory = cat);
                                  }
                                },
                                selectedColor: const Color(0xFF2563EB),
                                backgroundColor: const Color(0xFFF8FAFC),
                                side: BorderSide(
                                  color: isSel ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                labelStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                  color: isSel ? Colors.white : const Color(0xFF475569),
                                  fontFamily: 'Inter',
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // 2. Price Range
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Price Range',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              Text(
                                '\$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2563EB),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          RangeSlider(
                            values: _priceRange,
                            min: 0,
                            max: 2500,
                            divisions: 25,
                            activeColor: const Color(0xFF2563EB),
                            inactiveColor: const Color(0xFFE2E8F0),
                            onChanged: (vals) {
                              setModalState(() => _priceRange = vals);
                              setState(() => _priceRange = vals);
                            },
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('\$0', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                              Text('\$2,500+', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // 3. Brand Checkboxes
                          const Text(
                            'Brand',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children: ['Aura Signature', 'Nordic Loft', 'Studio M', 'Essence'].map((brand) {
                              final isChecked = _selectedBrands.contains(brand);
                              return InkWell(
                                onTap: () {
                                  setModalState(() {
                                    if (isChecked) {
                                      _selectedBrands.remove(brand);
                                    } else {
                                      _selectedBrands.add(brand);
                                    }
                                  });
                                  setState(() {});
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isChecked ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isChecked ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                        size: 18,
                                        color: isChecked ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        brand,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
                                          color: isChecked ? const Color(0xFF1E3A8A) : const Color(0xFF334155),
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // 4. Rating Section
                          const Text(
                            'Rating',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: ['4.0+', '4.5+'].map((rating) {
                              final isSel = _selectedRating == rating;
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ChoiceChip(
                                  avatar: const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                                  label: Text('★ $rating'),
                                  selected: isSel,
                                  onSelected: (sel) {
                                    setModalState(() => _selectedRating = sel ? rating : null);
                                    setState(() => _selectedRating = sel ? rating : null);
                                  },
                                  selectedColor: const Color(0xFFEFF6FF),
                                  backgroundColor: const Color(0xFFF8FAFC),
                                  side: BorderSide(
                                    color: isSel ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                  ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                                    color: isSel ? const Color(0xFF2563EB) : const Color(0xFF475569),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // 5. In Stock Only Toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'In Stock Only',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Text(
                                    'Only show items ready to ship',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _onlyInStock,
                                activeThumbColor: const Color(0xFF2563EB),
                                onChanged: (val) {
                                  setModalState(() => _onlyInStock = val);
                                  setState(() => _onlyInStock = val);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Action Buttons (Reset / Apply)
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                _selectedCategory = 'All Items';
                                _priceRange = const RangeValues(0, 1200);
                                _selectedBrands.clear();
                                _selectedRating = null;
                                _onlyInStock = false;
                              });
                              setState(() {});
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Apply Filters',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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

  @override
  Widget build(BuildContext context) {
    List<Product> results = [];
    if (_query.isNotEmpty) {
      if (_query.toLowerCase().contains('none') || _query.toLowerCase().contains('xyz')) {
        results = [];
      } else {
        results = ShopData.products.where((p) {
          return p.name.toLowerCase().contains(_query.toLowerCase()) ||
              p.category.toLowerCase().contains(_query.toLowerCase()) ||
              p.brand.toLowerCase().contains(_query.toLowerCase());
        }).toList();
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: widget.showBottomNav
          ? GrozzbyBottomNavBar(
              currentIndex: 2, // Search tab
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
            // 1. Shared Grozzby App Top Bar
            const GrozzbyAppTopBar(),

            // 2. Search Input Header Strip
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: Color(0xFF2563EB), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: false,
                        textInputAction: TextInputAction.search,
                        onSubmitted: _onSearch,
                        decoration: const InputDecoration(
                          hintText: 'Search products, brands and more...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF94A3B8),
                            fontFamily: 'Inter',
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF94A3B8)),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    else ...[
                      const Icon(Icons.mic_none_rounded, color: Color(0xFF94A3B8), size: 18),
                      const SizedBox(width: 8),
                      const Icon(Icons.camera_alt_outlined, color: Color(0xFF94A3B8), size: 18),
                    ],
                  ],
                ),
              ),
            ),

            // 3. Body View
            Expanded(
              child: _query.isEmpty
                  ? _buildInitialSearchState()
                  : (results.isEmpty ? _buildNoResultsState() : _buildSearchResultsState(results)),
            ),
          ],
        ),
      ),
    );
  }

  // --- Screen 3: Initial Search State (Figma 120:118) ---
  Widget _buildInitialSearchState() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // Recent Searches
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                  fontFamily: 'Inter',
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _recentSearches.clear()),
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((item) {
              return ActionChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item),
                    const SizedBox(width: 4),
                    const Icon(Icons.close_rounded, size: 14, color: Color(0xFF94A3B8)),
                  ],
                ),
                backgroundColor: AppColors.white,
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                labelStyle: const TextStyle(fontSize: 12, color: Color(0xFF334155), fontFamily: 'Inter'),
                onPressed: () {
                  _searchController.text = item;
                  _onSearch(item);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],

        // Trending Searches
        const Text(
          'Trending Searches',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _trendingSearches.map((tag) {
            return ActionChip(
              avatar: const Icon(Icons.trending_up_rounded, size: 16, color: Color(0xFF2563EB)),
              label: Text(tag),
              backgroundColor: const Color(0xFFEFF6FF),
              side: const BorderSide(color: Color(0xFFBFDBFE)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E40AF),
                fontFamily: 'Inter',
              ),
              onPressed: () {
                _searchController.text = tag;
                _onSearch(tag);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Trending Now (Editor's Pick "Warm Minimalism")
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.bolt_rounded, size: 18, color: Color(0xFFF59E0B)),
                SizedBox(width: 4),
                Text(
                  'Trending Now',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () => _onSearch('Watches'),
              child: const Text(
                'See All >',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 170,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=600&auto=format&fit=crop&q=60'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "EDITOR'S PICK",
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Warm Minimalism',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _onSearch('Furniture'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Explore Now →',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 2-card row
        Row(
          children: [
            Expanded(
              child: _buildTrendingMiniCard(
                'Mechanical Keyboards',
                'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400&auto=format&fit=crop&q=60',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTrendingMiniCard(
                'Eco-Runner Pro',
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&auto=format&fit=crop&q=60',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Recently Viewed
        const Text(
          'Recently Viewed',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildRecentlyViewedItem('AirPods Max', '₹59,900', 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=300&auto=format&fit=crop&q=60'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRecentlyViewedItem('Nike Air Max', '₹8,495', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300&auto=format&fit=crop&q=60'),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Popular Categories
        const Text(
          'Popular Categories',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCategoryIcon(Icons.checkroom_rounded, 'Fashion', const Color(0xFFFFF7ED), const Color(0xFFEA580C)),
            _buildCategoryIcon(Icons.devices_rounded, 'Electronics', const Color(0xFFEFF6FF), const Color(0xFF2563EB)),
            _buildCategoryIcon(Icons.spa_rounded, 'Beauty', const Color(0xFFFDF2F8), const Color(0xFFDB2777)),
            _buildCategoryIcon(Icons.chair_rounded, 'Home', const Color(0xFFECFDF5), const Color(0xFF059669)),
            _buildCategoryIcon(Icons.sports_basketball_rounded, 'Sports', const Color(0xFFF0FDF4), const Color(0xFF16A34A)),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTrendingMiniCard(String title, String imageUrl) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildRecentlyViewedItem(String title, String price, String img) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(img, width: 44, height: 44, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                Text(price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2563EB))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label, Color bg, Color color) {
    return InkWell(
      onTap: () => _onSearch(label),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
        ],
      ),
    );
  }

  // --- Screen 4: Search Results State (Figma 90:727) ---
  Widget _buildSearchResultsState(List<Product> results) {
    return Column(
      children: [
        // Subheader: "Premium Watches - 84 Products • Free Shipping"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      _searchController.clear();
                      _onSearch('');
                    },
                    child: const Icon(Icons.arrow_back_rounded, size: 20, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _query.isNotEmpty ? _query : 'Search Results',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Text(
                        '${results.length} Products • Free Shipping',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 20, color: Color(0xFF64748B)),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Horizontal Filter Chips Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              InkWell(
                onTap: _openAdvancedFilters,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.tune_rounded, size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      Text('Filter', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildFilterPill('Brand ▾'),
              _buildFilterPill('Watch Type ▾'),
              _buildFilterPill('Price ▾'),
              _buildFilterPill('In Stock'),
            ],
          ),
        ),

        // Trust strip
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.local_shipping_outlined, size: 14, color: Color(0xFF2563EB)),
                      SizedBox(width: 6),
                      Text('Free Delivery on ₹499+', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF1E40AF))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.replay_rounded, size: 14, color: Color(0xFF059669)),
                      SizedBox(width: 6),
                      Text('15 Days Return Policy', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF065F46))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // 2-Column Product Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final product = results[index];
              return _buildSearchResultProductCard(context, product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPill(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: _openAdvancedFilters,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultProductCard(BuildContext context, Product product) {
    final cart = context.read<CartProvider>();
    return InkWell(
      onTap: () => context.push('/product-details', extra: product),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Discount Tag
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.network(
                  product.imageUrl,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, stackTrace) => Container(
                    height: 130,
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.image, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '-40%',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand.toUpperCase(),
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 2),
                    Text(
                      '${product.rating} (${product.reviewCount})',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '₹${(product.price * 1.5).toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 11, decoration: TextDecoration.lineThrough, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      cart.addItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart!'),
                          backgroundColor: const Color(0xFF2563EB),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
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
    );
  }

  // --- Screen 6: No Results Found State (Figma 101:47) ---
  Widget _buildNoResultsState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Illustration / Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No results for',
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontFamily: 'Inter'),
          ),
          Text(
            '"$_query"',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try another keyword or browse our trending products.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 20),

          // Search Again Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: Color(0xFF2563EB), size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Search again...',
                    style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  ),
                ),
                const Icon(Icons.mic_none_rounded, color: Color(0xFF94A3B8), size: 16),
                const SizedBox(width: 6),
                const Icon(Icons.camera_alt_outlined, color: Color(0xFF94A3B8), size: 16),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Try Searching Chips
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Try searching',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Smart Watches', 'Analog Watches', 'Casio', 'Fossil', 'Titan'].map((kw) {
              return ActionChip(
                avatar: const Icon(Icons.search_rounded, size: 14, color: Color(0xFF2563EB)),
                label: Text(kw),
                backgroundColor: AppColors.white,
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                onPressed: () {
                  _searchController.text = kw;
                  _onSearch(kw);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Did You Mean? box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.help_outline_rounded, size: 16, color: Color(0xFF2563EB)),
                const SizedBox(width: 8),
                const Text('Did you mean? ', style: TextStyle(fontSize: 12, color: Color(0xFF475569))),
                InkWell(
                  onTap: () {
                    _searchController.text = 'Premium Watch';
                    _onSearch('Premium Watch');
                  },
                  child: const Text(
                    'Premium Watch',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons: Explore Trending & Go to Home
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _searchController.text = 'Watches';
                    _onSearch('Watches');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Explore Trending', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go('/home'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Go to Home', style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
