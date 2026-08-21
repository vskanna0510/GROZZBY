import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/data/cart_provider.dart';
import '../../profile/data/addresses_provider.dart';
import 'widgets/checkout_top_bar.dart';
import 'widgets/checkout_stepper.dart';
import 'widgets/address_item_card.dart';

class CheckoutAddressScreen extends StatefulWidget {
  const CheckoutAddressScreen({super.key});

  @override
  State<CheckoutAddressScreen> createState() => _CheckoutAddressScreenState();
}

class _CheckoutAddressScreenState extends State<CheckoutAddressScreen> {
  String? _selectedAddressId;
  String _selectedDeliverySpeed = 'express'; // 'express' or 'standard'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addresses = context.read<AddressesProvider>().addresses;
      if (addresses.isNotEmpty) {
        setState(() {
          _selectedAddressId = addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first).id;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final addressesProv = context.watch<AddressesProvider>();
    final addresses = addressesProv.addresses;

    final selectedAddress = addresses.firstWhere(
      (a) => a.id == _selectedAddressId,
      orElse: () => addresses.isNotEmpty ? addresses.first : addressesProv.defaultAddress,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            CheckoutTopBar(
              cartCount: cart.totalItemCount,
              onLocationTap: () => context.push('/profile/addresses'),
            ),

            // Stepper (Address Step active)
            const CheckoutStepper(
              currentStep: CheckoutStep.address,
            ),

            // Navigation Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => context.pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 18,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address Book',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Inter',
                            ),
                          ),
                          Text(
                            'Manage your shipping destinations',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Add Address Button
                  OutlinedButton.icon(
                    onPressed: () => context.push('/checkout/address/add'),
                    icon: const Icon(Icons.add_rounded, size: 16, color: AppColors.primary),
                    label: const Text(
                      'Add Address',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        fontFamily: 'Inter',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFBFDBFE)),
                      backgroundColor: const Color(0xFFEFF6FF),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable List of Addresses
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Speed Selector
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DELIVERY SPEED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF64748B),
                              letterSpacing: 0.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedDeliverySpeed = 'express'),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _selectedDeliverySpeed == 'express'
                                          ? const Color(0xFFEFF6FF)
                                          : const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _selectedDeliverySpeed == 'express'
                                            ? AppColors.primary
                                            : const Color(0xFFE2E8F0),
                                        width: _selectedDeliverySpeed == 'express' ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.electric_bolt_rounded,
                                          size: 18,
                                          color: _selectedDeliverySpeed == 'express'
                                              ? AppColors.primary
                                              : const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 8),
                                        const Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Express Delivery',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF0F172A),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            Text(
                                              '15–20 mins',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFF16A34A),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedDeliverySpeed = 'standard'),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _selectedDeliverySpeed == 'standard'
                                          ? const Color(0xFFEFF6FF)
                                          : const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _selectedDeliverySpeed == 'standard'
                                            ? AppColors.primary
                                            : const Color(0xFFE2E8F0),
                                        width: _selectedDeliverySpeed == 'standard' ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.schedule_rounded,
                                          size: 18,
                                          color: _selectedDeliverySpeed == 'standard'
                                              ? AppColors.primary
                                              : const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 8),
                                        const Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Scheduled Slot',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF0F172A),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            Text(
                                              'Today 4:00–6:00 PM',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFF64748B),
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Saved Addresses
                    const Text(
                      'SELECT SAVED ADDRESS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.6,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...addresses.map((addr) {
                      final isSelected = addr.id == _selectedAddressId;
                      return AddressItemCard(
                        address: addr,
                        isSelected: isSelected,
                        onSelect: () => setState(() => _selectedAddressId = addr.id),
                        onEdit: () => context.push('/checkout/address/edit', extra: addr),
                      );
                    }),

                    const SizedBox(height: 12),

                    // Add New Address Button Outline
                    InkWell(
                      onTap: () => context.push('/checkout/address/add'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF93C5FD),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_location_alt_outlined, size: 18, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              '+ Add Another Delivery Address',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
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
            ),

            // Fixed Bottom CTA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Deliver to',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF64748B),
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          selectedAddress.label.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/checkout/payment', extra: selectedAddress);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue to Payment',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
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
