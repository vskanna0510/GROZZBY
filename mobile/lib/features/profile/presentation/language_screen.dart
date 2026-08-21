import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'en_US';

  final List<Map<String, dynamic>> _languages = [
    {
      'id': 'en_US',
      'name': 'English (United States)',
      'subtitle': 'Default System Language',
      'iconBg': Color(0xFFDDE1FF),
      'iconColor': Color(0xFF00288E),
      'iconType': 'globe',
    },
    {
      'id': 'es',
      'name': 'Español',
      'subtitle': 'Spanish',
      'iconBg': Color(0xFFD3E4FE),
      'iconColor': Color(0xFF1E40AF),
      'iconType': 'earth',
    },
    {
      'id': 'fr',
      'name': 'Français',
      'subtitle': 'French',
      'iconBg': Color(0xFFC9E6FF),
      'iconColor': Color(0xFF0284C7),
      'iconType': 'translate',
    },
    {
      'id': 'de',
      'name': 'Deutsch',
      'subtitle': 'German',
      'iconBg': Color(0xFFD3E4FE),
      'iconColor': Color(0xFF1E40AF),
      'iconType': 'earth',
    },
    {
      'id': 'ta',
      'name': 'Tamil',
      'subtitle': 'தமிழ்',
      'iconBg': Color(0xFFDDE1FF),
      'iconColor': Color(0xFF00288E),
      'iconType': 'globe',
    },
    {
      'id': 'ja',
      'name': 'Japanese',
      'subtitle': '日本語',
      'iconBg': Color(0xFFC9E6FF),
      'iconColor': Color(0xFF0284C7),
      'iconType': 'translate',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            // Top App Bar
            const GrozzbyAppTopBar(),

            // Header Navigation (Back Button, Title)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
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
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Language',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Scrollable Main Content matching Figma Node 277:5396
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title & Description
                    const Text(
                      'Display Language',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF191C1E),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Choose your preferred language for the Grozzy interface. This will affect all menus, buttons, and system notifications.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF444653),
                        height: 1.5,
                        fontFamily: 'Inter',
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Language Selection List Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE0E3E5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: _languages.asMap().entries.map((entry) {
                          final index = entry.key;
                          final lang = entry.value;
                          final isSelected = _selectedLanguage == lang['id'];

                          return Column(
                            children: [
                              if (index > 0)
                                const Divider(height: 1, color: Color(0xFFE0E3E5)),
                              Material(
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedLanguage = lang['id'];
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                    child: Row(
                                      children: [
                                        // Language Icon
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: lang['iconBg'] as Color,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: _buildLanguageIcon(
                                              lang['iconType'] as String,
                                              lang['iconColor'] as Color,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),

                                        // Language Names
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                lang['name'] as String,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF191C1E),
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                lang['subtitle'] as String,
                                                style: const TextStyle(
                                                  fontSize: 12.5,
                                                  color: Color(0xFF444653),
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Radio Button
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected ? const Color(0xFF00288E) : Colors.white,
                                            border: Border.all(
                                              color: isSelected ? const Color(0xFF00288E) : const Color(0xFF757684),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: isSelected
                                              ? Center(
                                                  child: Container(
                                                    width: 7,
                                                    height: 7,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Impact of change Note Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD0E1FB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: Color(0xFF54647A),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Impact of change',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF54647A),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Changing your language preference will reload the application. Some regional data, like dates and currencies, will automatically adjust to the new locale.',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF54647A),
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

                    const SizedBox(height: 24),

                    // Action Buttons (Cancel & Apply Changes)
                    Column(
                      children: [
                        // Cancel Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/profile');
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF00288E),
                              side: const BorderSide(color: Color(0xFF757684), width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Apply Changes Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              final selected = _languages.firstWhere((l) => l['id'] == _selectedLanguage);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Language preference applied: ${selected['name']}'),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: const Color(0xFF16A34A),
                                ),
                              );
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/profile');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00288E),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Apply Changes',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildLanguageIcon(String type, Color color) {
    switch (type) {
      case 'globe':
        return Icon(Icons.language_rounded, size: 20, color: color);
      case 'earth':
        return Icon(Icons.public_rounded, size: 20, color: color);
      case 'translate':
        return Icon(Icons.translate_rounded, size: 20, color: color);
      default:
        return Icon(Icons.language_rounded, size: 20, color: color);
    }
  }
}
