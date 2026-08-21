import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/cart/data/cart_provider.dart';

enum BottomNavVariant {
  fiveItem, // Home, Categories, Search, Cart, Account
}

class GrozzbyBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final BottomNavVariant variant;

  const GrozzbyBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.variant = BottomNavVariant.fiveItem,
  });

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
    } else {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalItemCount;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFFBFBFB),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavTabItem(
                index: 0,
                iconType: _NavIconType.home,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => _handleTap(context, 0),
              ),
              _NavTabItem(
                index: 1,
                iconType: _NavIconType.categories,
                label: 'Categories',
                isSelected: currentIndex == 1,
                onTap: () => _handleTap(context, 1),
              ),
              _NavTabItem(
                index: 2,
                iconType: _NavIconType.search,
                label: 'Search',
                isSelected: currentIndex == 2,
                onTap: () => _handleTap(context, 2),
              ),
              _NavTabItem(
                index: 3,
                iconType: _NavIconType.cart,
                label: 'Cart',
                isSelected: currentIndex == 3,
                badgeCount: cartCount,
                onTap: () => _handleTap(context, 3),
              ),
              _NavTabItem(
                index: 4,
                iconType: _NavIconType.account,
                label: 'Account',
                isSelected: currentIndex == 4,
                onTap: () => _handleTap(context, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _NavIconType { home, categories, search, cart, account }

class _NavTabItem extends StatelessWidget {
  final int index;
  final _NavIconType iconType;
  final String label;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavTabItem({
    required this.index,
    required this.iconType,
    required this.label,
    required this.isSelected,
    this.badgeCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? Colors.white : const Color(0xFF191C1D);
    final inactiveColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563);
    final color = isSelected ? activeColor : inactiveColor;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: const Color(0xFF00288E).withValues(alpha: 0.06),
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: Center(
                      child: CustomPaint(
                        size: const Size(24, 24),
                        painter: _NavIconCustomPainter(
                          type: iconType,
                          color: color,
                          strokeWidth: isSelected ? 2.2 : 1.9,
                        ),
                      ),
                    ),
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      top: -3,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00288E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          badgeCount > 99 ? '99+' : badgeCount.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                  color: color,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIconCustomPainter extends CustomPainter {
  final _NavIconType type;
  final Color color;
  final double strokeWidth;

  _NavIconCustomPainter({
    required this.type,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    switch (type) {
      case _NavIconType.home:
        // Precise house shape with inner door outline
        final path = Path();
        // Roof apex
        path.moveTo(w * 0.5, h * 0.12);
        // Roof left slope
        path.lineTo(w * 0.14, h * 0.44);
        // Left wall
        path.lineTo(w * 0.14, h * 0.88);
        // Bottom left to door
        path.lineTo(w * 0.38, h * 0.88);
        // Door up
        path.lineTo(w * 0.38, h * 0.56);
        // Door top
        path.lineTo(w * 0.62, h * 0.56);
        // Door down
        path.lineTo(w * 0.62, h * 0.88);
        // Bottom right
        path.lineTo(w * 0.86, h * 0.88);
        // Right wall
        path.lineTo(w * 0.86, h * 0.44);
        // Roof right slope to apex
        path.close();
        canvas.drawPath(path, paint);
        break;

      case _NavIconType.categories:
        // 4 rounded square boxes in a 2x2 grid
        const boxSize = 7.0;
        const radius = Radius.circular(2.2);

        // Top-Left box
        final r1 = RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.12, h * 0.14, boxSize, boxSize),
          radius,
        );
        // Top-Right box
        final r2 = RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.58, h * 0.14, boxSize, boxSize),
          radius,
        );
        // Bottom-Left box
        final r3 = RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.12, h * 0.58, boxSize, boxSize),
          radius,
        );
        // Bottom-Right box
        final r4 = RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.58, h * 0.58, boxSize, boxSize),
          radius,
        );

        canvas.drawRRect(r1, paint);
        canvas.drawRRect(r2, paint);
        canvas.drawRRect(r3, paint);
        canvas.drawRRect(r4, paint);
        break;

      case _NavIconType.search:
        // Search magnifying glass
        const center = Offset(10.0, 10.0);
        const radiusVal = 6.8;
        canvas.drawCircle(center, radiusVal, paint);

        // Handle
        canvas.drawLine(
          const Offset(15.2, 15.2),
          const Offset(21.5, 21.5),
          paint,
        );
        break;

      case _NavIconType.cart:
        // Shopping cart outline
        final cartPath = Path();
        // Handle start
        cartPath.moveTo(w * 0.08, h * 0.18);
        cartPath.lineTo(w * 0.22, h * 0.18);
        // Top front basket
        cartPath.lineTo(w * 0.34, h * 0.62);
        // Basket bottom
        cartPath.lineTo(w * 0.88, h * 0.62);
        // Basket back slanted
        cartPath.lineTo(w * 0.94, h * 0.30);
        // Basket top line
        cartPath.lineTo(w * 0.26, h * 0.30);
        canvas.drawPath(cartPath, paint);

        // Wheel 1 (left)
        canvas.drawCircle(Offset(w * 0.40, h * 0.84), 1.8, fillPaint);
        // Wheel 2 (right)
        canvas.drawCircle(Offset(w * 0.80, h * 0.84), 1.8, fillPaint);
        break;

      case _NavIconType.account:
        // Person head circle
        canvas.drawCircle(Offset(w * 0.5, h * 0.32), 4.2, paint);

        // Person shoulders curve
        final bodyPath = Path();
        bodyPath.moveTo(w * 0.18, h * 0.88);
        bodyPath.cubicTo(
          w * 0.20,
          h * 0.58,
          w * 0.80,
          h * 0.58,
          w * 0.82,
          h * 0.88,
        );
        canvas.drawPath(bodyPath, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _NavIconCustomPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
