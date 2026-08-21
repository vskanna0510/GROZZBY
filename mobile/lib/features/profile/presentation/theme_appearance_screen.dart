import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ThemeAppearanceScreen extends StatefulWidget {
  const ThemeAppearanceScreen({super.key});

  @override
  State<ThemeAppearanceScreen> createState() => _ThemeAppearanceScreenState();
}

class _ThemeAppearanceScreenState extends State<ThemeAppearanceScreen> {
  String _selectedTheme = 'system'; // 'system', 'light', 'dark'
  int _selectedColorIndex = 0;
  bool _highContrast = false;
  bool _reduceMotion = false;
  bool _compactDensity = false;

  final List<Color> _accentColors = const [
    Color(0xFF1778BD), // Grozzby Blue
    Color(0xFF059669), // Emerald
    Color(0xFF7C3AED), // Violet
    Color(0xFFEA580C), // Orange
    Color(0xFFE11D48), // Rose
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.neutral900),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Theme & Appearance',
          style: AppTextStyles.headingBold18.copyWith(color: AppColors.neutral900),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Mode Selector
            Text('Appearance Mode', style: AppTextStyles.accountSectionTitle),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildThemeCard(
                  id: 'system',
                  title: 'System',
                  icon: Icons.phone_android_rounded,
                  previewColor: const Color(0xFFE2E8F0),
                ),
                const SizedBox(width: 12),
                _buildThemeCard(
                  id: 'light',
                  title: 'Light',
                  icon: Icons.light_mode_rounded,
                  previewColor: Colors.white,
                ),
                const SizedBox(width: 12),
                _buildThemeCard(
                  id: 'dark',
                  title: 'Dark',
                  icon: Icons.dark_mode_rounded,
                  previewColor: const Color(0xFF0F172A),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Section 2: Accent Palette
            Text('Accent Color', style: AppTextStyles.accountSectionTitle),
            const SizedBox(height: 6),
            Text(
              'Customize buttons, badges, and active highlights.',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_accentColors.length, (index) {
                  final color = _accentColors[index];
                  final isSelected = _selectedColorIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedColorIndex = index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Theme accent updated'), duration: Duration(milliseconds: 800)),
                      );
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: AppColors.neutral900, width: 3) : null,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: isSelected
                          ? const Center(child: Icon(Icons.check_rounded, color: Colors.white, size: 22))
                          : null,
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 28),

            // Section 3: Accessibility & Visual Toggles
            Text('Accessibility & Motion', style: AppTextStyles.accountSectionTitle),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _highContrast,
                    onChanged: (val) => setState(() => _highContrast = val),
                    activeTrackColor: AppColors.primary,
                    title: Text('High Contrast', style: AppTextStyles.bodySemiBold14),
                    subtitle: Text('Increase text and border clarity', style: AppTextStyles.caption),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.settingIndigoBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.contrast_rounded, color: AppColors.settingIndigo, size: 20),
                    ),
                  ),
                  const Divider(height: 1, indent: 68, color: AppColors.neutral100),
                  SwitchListTile(
                    value: _reduceMotion,
                    onChanged: (val) => setState(() => _reduceMotion = val),
                    activeTrackColor: AppColors.primary,
                    title: Text('Reduce Motion', style: AppTextStyles.bodySemiBold14),
                    subtitle: Text('Minimize transitions and animated effects', style: AppTextStyles.caption),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.settingVioletBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.motion_photos_off_rounded, color: AppColors.settingViolet, size: 20),
                    ),
                  ),
                  const Divider(height: 1, indent: 68, color: AppColors.neutral100),
                  SwitchListTile(
                    value: _compactDensity,
                    onChanged: (val) => setState(() => _compactDensity = val),
                    activeTrackColor: AppColors.primary,
                    title: Text('Compact View Mode', style: AppTextStyles.bodySemiBold14),
                    subtitle: Text('Show more items per screen', style: AppTextStyles.caption),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.settingCyanBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.density_medium_rounded, color: AppColors.settingCyan, size: 20),
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

  Widget _buildThemeCard({
    required String id,
    required String title,
    required IconData icon,
    required Color previewColor,
  }) {
    final isSelected = _selectedTheme == id;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTheme = id),
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.neutral200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: previewColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.neutral300, width: 1),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: id == 'dark' ? Colors.white : AppColors.neutral800,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.neutral800,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primary),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
