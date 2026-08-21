import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/addresses_provider.dart';
import '../../shop/models/address.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  void _showAddressModal(BuildContext context, {DeliveryAddress? existing}) {
    final nameCtrl = TextEditingController(text: existing?.recipientName ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phoneNumber ?? '');
    final streetCtrl = TextEditingController(text: existing?.streetAddress ?? '');
    final aptCtrl = TextEditingController(text: existing?.apartment ?? '');
    final cityCtrl = TextEditingController(text: existing?.city ?? 'Springfield');
    final zipCtrl = TextEditingController(text: existing?.postalCode ?? '97477');
    String label = existing?.label ?? 'Home';
    bool isDefault = existing?.isDefault ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          existing != null ? 'Edit Address' : 'Add New Address',
                          style: AppTextStyles.headingBold20,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Label chips
                    Row(
                      children: ['Home', 'Work', 'Other'].map((l) {
                        final isSel = label == l;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(l),
                            selected: isSel,
                            onSelected: (sel) {
                              if (sel) setModalState(() => label = l);
                            },
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(color: isSel ? AppColors.white : AppColors.neutral800),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    _buildField(label: 'Full Name', controller: nameCtrl, hint: 'Alex Johnson'),
                    const SizedBox(height: 10),
                    _buildField(label: 'Phone Number', controller: phoneCtrl, hint: '+1 (555) 000-0000', keyboardType: TextInputType.phone),
                    const SizedBox(height: 10),
                    _buildField(label: 'Street Address', controller: streetCtrl, hint: '123 Grocery Way'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildField(label: 'Apartment / Suite', controller: aptCtrl, hint: 'Apt 2B')),
                        const SizedBox(width: 10),
                        Expanded(child: _buildField(label: 'ZIP Code', controller: zipCtrl, hint: '97477')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildField(label: 'City', controller: cityCtrl, hint: 'Springfield'),

                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: Text('Set as Default Delivery Address', style: AppTextStyles.bodySemiBold14),
                      value: isDefault,
                      activeThumbColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setModalState(() => isDefault = val),
                    ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (nameCtrl.text.isNotEmpty && streetCtrl.text.isNotEmpty) {
                          final addressesProvider = context.read<AddressesProvider>();
                          final addr = DeliveryAddress(
                            id: existing?.id ?? 'addr_${DateTime.now().millisecondsSinceEpoch}',
                            label: label,
                            recipientName: nameCtrl.text.trim(),
                            phoneNumber: phoneCtrl.text.trim(),
                            streetAddress: streetCtrl.text.trim(),
                            apartment: aptCtrl.text.trim(),
                            city: cityCtrl.text.trim(),
                            postalCode: zipCtrl.text.trim(),
                            isDefault: isDefault,
                          );

                          if (existing != null) {
                            addressesProvider.updateAddress(addr);
                          } else {
                            addressesProvider.addAddress(addr);
                          }
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        existing != null ? 'Save Changes' : 'Save Address',
                        style: AppTextStyles.bodySemiBold14.copyWith(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelBold12Inter.copyWith(fontSize: 11, color: AppColors.neutral700)),
        const SizedBox(height: 4),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.neutral50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextStyles.bodySemiBold14.copyWith(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.captionRegular10.copyWith(fontSize: 12),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressesProvider = context.watch<AddressesProvider>();
    final addresses = addressesProvider.addresses;

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
          'Saved Addresses',
          style: AppTextStyles.headingBold20.copyWith(color: AppColors.neutral900),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        itemCount: addresses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final addr = addresses[index];

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: addr.isDefault ? AppColors.primary : AppColors.neutral200,
                width: addr.isDefault ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: addr.label == 'Home'
                            ? AppColors.primaryLight
                            : addr.label == 'Work'
                                ? AppColors.warning.withValues(alpha: 0.15)
                                : AppColors.categoryBg6,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        addr.label == 'Home'
                            ? Icons.home_rounded
                            : addr.label == 'Work'
                                ? Icons.business_rounded
                                : Icons.location_on_rounded,
                        color: addr.label == 'Home' ? AppColors.primary : AppColors.neutral800,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(addr.label, style: AppTextStyles.bodySemiBold14),
                    if (addr.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'DEFAULT',
                          style: AppTextStyles.captionBlack10.copyWith(color: AppColors.white, fontSize: 9),
                        ),
                      ),
                    ],
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.neutral600),
                      onPressed: () => _showAddressModal(context, existing: addr),
                    ),
                    if (!addr.isDefault)
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.danger),
                        onPressed: () => addressesProvider.deleteAddress(addr.id),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(addr.recipientName, style: AppTextStyles.bodySemiBold14.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(addr.fullAddress, style: AppTextStyles.bodyRegular13.copyWith(color: AppColors.neutral600)),
                const SizedBox(height: 2),
                Text(addr.phoneNumber, style: AppTextStyles.captionRegular10.copyWith(color: AppColors.neutral500)),
                if (!addr.isDefault) ...[
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => addressesProvider.setDefault(addr.id),
                    child: Text(
                      'Set as Default',
                      style: AppTextStyles.labelBold12Inter.copyWith(color: AppColors.primary, fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: const Border(top: BorderSide(color: AppColors.neutral200)),
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () => _showAddressModal(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.add_location_alt_rounded, color: AppColors.white),
            label: Text('Add New Address', style: AppTextStyles.bodySemiBold16.copyWith(color: AppColors.white)),
          ),
        ),
      ),
    );
  }
}
