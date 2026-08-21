import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How fast will my grocery order be delivered?',
      'answer':
          'Grozzby offers standard Express delivery in 15–25 minutes for all addresses within our city operational zone. You can track your courier live in real-time from the "Track Order" page.',
      'category': 'Delivery',
    },
    {
      'question': 'What if an item is damaged or missing from my bag?',
      'answer':
          'We guarantee 100% freshness. If any fruit, vegetable, or package is damaged or missing, simply click "Help" on your order card for an instant refund to your Grozzby wallet or original payment method.',
      'category': 'Refunds',
    },
    {
      'question': 'How do I apply coupon and promo codes?',
      'answer':
          'You can enter your voucher code (like GROZZBY10 or SAVE50) directly on the Cart Screen before proceeding to checkout. The discount applies immediately to your item subtotal.',
      'category': 'Offers',
    },
    {
      'question': 'Can I schedule my delivery for later today?',
      'answer':
          'Yes! On the Checkout Address screen, you can choose from Express Delivery, Today Afternoon (2-4 PM), or Today Evening (6-8 PM) delivery slots.',
      'category': 'Delivery',
    },
    {
      'question': 'What payment methods do you accept?',
      'answer':
          'We accept Apple Pay, Google Pay, all major Credit/Debit cards (Visa, MasterCard, Amex), UPI, Grozzby Wallet, and Cash on Delivery.',
      'category': 'Payment',
    },
  ];

  void _showMessageSheet() {
    final msgCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Send Inquiry Ticket', style: AppTextStyles.headingBold20),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Our customer support team typically replies in under 15 minutes.',
              style: AppTextStyles.captionRegular10.copyWith(color: AppColors.neutral500, fontSize: 12),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: TextField(
                controller: msgCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe your issue or feedback in detail...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (msgCtrl.text.isNotEmpty) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Support ticket submitted! Ticket #TK-8910')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Submit Ticket', style: AppTextStyles.bodySemiBold14.copyWith(color: AppColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _searchQuery.isEmpty
        ? _faqs
        : _faqs
            .where((f) =>
                f['question']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                f['answer']!.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.neutral900, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Help & Support',
          style: AppTextStyles.headingBold20.copyWith(color: AppColors.neutral900),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search FAQs banner
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
                decoration: InputDecoration(
                  hintText: 'Search help topics and FAQs...',
                  hintStyle: AppTextStyles.bodyRegular14.copyWith(color: AppColors.neutral400, fontSize: 13),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quick Contact Options
            Text('Contact Us 24/7', style: AppTextStyles.headingBold18.copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _ContactCard(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Live Chat',
                    subtitle: 'Instant support',
                    color: AppColors.primary,
                    onTap: _showMessageSheet,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ContactCard(
                    icon: Icons.call_outlined,
                    title: 'Call Us',
                    subtitle: '1-800-GROZZBY',
                    color: AppColors.success,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dialing +1 (800) 476-9929...')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ContactCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: 'support@grozzby.com',
                    color: AppColors.accentSky,
                    onTap: _showMessageSheet,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Frequently Asked Questions
            Text('Frequently Asked Questions', style: AppTextStyles.headingBold18.copyWith(fontSize: 16)),
            const SizedBox(height: 10),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredFaqs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final faq = filteredFaqs[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.neutral200),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(
                        faq['question']!,
                        style: AppTextStyles.bodySemiBold14.copyWith(
                          fontSize: 13.5,
                          color: AppColors.neutral900,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            faq['answer']!,
                            style: AppTextStyles.bodyRegular14.copyWith(
                              color: AppColors.neutral600,
                              height: 1.45,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySemiBold14.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionRegular10.copyWith(color: AppColors.neutral500, fontSize: 9.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
