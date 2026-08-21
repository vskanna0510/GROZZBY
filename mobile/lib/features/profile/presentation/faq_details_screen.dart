import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/grozzby_app_top_bar.dart';
import '../../../shared/widgets/grozzby_bottom_nav_bar.dart';

class FaqDetailsScreen extends StatefulWidget {
  const FaqDetailsScreen({super.key});

  @override
  State<FaqDetailsScreen> createState() => _FaqDetailsScreenState();
}

class _FaqDetailsScreenState extends State<FaqDetailsScreen> {
  final Set<int> _expandedIndices = {}; // Collapsed by default matching screenshot

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How can I track my order status?',
      'answer': 'Once your order ships, you will receive a confirmation email and SMS with a live tracking link. You can also track your order in real-time with GPS rider location from the Orders tab in the app.',
    },
    {
      'question': 'What are your international shipping rates?',
      'answer': 'We offer standard international shipping starting from \$14.99 and express courier shipping from \$24.99. Delivery times range between 3 to 7 business days depending on customs and destination.',
    },
    {
      'question': 'Can I change my shipping address after placing an order?',
      'answer': 'Yes, you can modify your delivery address within 15 minutes of order placement directly from the Order Details screen or by connecting with our 24/7 concierge team via Live Chat.',
    },
    {
      'question': "What should I do if my package is marked as delivered but I haven't received it?",
      'answer': 'Please verify with household members or reception first. If you still cannot locate your parcel within 2 hours of delivery notification, tap Contact Support for an immediate free replacement or refund.',
    },
    {
      'question': 'Do you offer free shipping?',
      'answer': 'Yes! All grocery orders above ₹499 (or \$50) qualify for complimentary standard delivery. Aura Club members enjoy unlimited free express delivery on every order.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      bottomNavigationBar: GrozzbyBottomNavBar(
        currentIndex: 4, // Profile / Support tab
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
            // Top App Bar with location, logo and notification bell
            const GrozzbyAppTopBar(),

            // Scrollable Content matching Figma node 277:4810 & Uploaded Screenshot
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumbs: Support > Orders & Shipping
                    Row(
                      children: [
                        InkWell(
                          onTap: () => context.go('/support'),
                          child: const Text(
                            'Support',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF505050),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '›',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF505050),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Orders & Shipping',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF191C1D),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Large Hero Heading: Orders &\nShipping
                    const Text(
                      'Orders &\nShipping',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF191C1D),
                        height: 1.15,
                        letterSpacing: -0.96,
                        fontFamily: 'Inter',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle / Supporting paragraph
                    const Text(
                      'Everything you need to know about tracking your Aura Shop treasures, managing deliveries, and understanding our shipping policies.',
                      style: TextStyle(
                        fontSize: 14.5,
                        color: Color(0xFF504533),
                        height: 1.55,
                        fontFamily: 'Inter',
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 5 FAQ Accordion Cards
                    ...List.generate(_faqs.length, (index) {
                      final faq = _faqs[index];
                      final isExpanded = _expandedIndices.contains(index);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (isExpanded) {
                                  _expandedIndices.remove(index);
                                } else {
                                  _expandedIndices.add(index);
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          faq['question']!,
                                          style: const TextStyle(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF191C1D),
                                            height: 1.35,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      AnimatedRotation(
                                        turns: isExpanded ? 0.5 : 0.0,
                                        duration: const Duration(milliseconds: 200),
                                        child: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 20,
                                          color: Color(0xFF505050),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isExpanded) ...[
                                    const SizedBox(height: 14),
                                    Text(
                                      faq['answer']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF504533),
                                        height: 1.55,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 32),

                    // Still need help? Card matching Figma Node 277:4810 & Uploaded Screenshot
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
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF191C1D),
                              letterSpacing: -0.3,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Can't find the answer you're looking for? Our dedicated support team is available 24/7 to assist you.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF505050),
                              height: 1.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Primary CTA: Contact Support (Dark Royal Blue with chat icon)
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () => context.push('/support/contact'),
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
                                  Icon(Icons.chat_bubble_outline_rounded, size: 18, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Contact Support',
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

                          // Secondary CTA: Email Us (White with border and mail icon)
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton(
                              onPressed: () => context.push('/support/contact'),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF261900),
                                side: const BorderSide(color: Color(0x33261900)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.mail_outline_rounded, size: 18, color: Color(0xFF261900)),
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
}
