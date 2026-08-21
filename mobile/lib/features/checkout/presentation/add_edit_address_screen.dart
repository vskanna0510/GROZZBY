import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/data/cart_provider.dart';
import '../../profile/data/addresses_provider.dart';
import '../../shop/models/address.dart';
import 'widgets/checkout_top_bar.dart';

class AddEditAddressScreen extends StatefulWidget {
  final DeliveryAddress? addressToEdit;

  const AddEditAddressScreen({super.key, this.addressToEdit});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _pincodeController;
  late TextEditingController _flatController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;

  String _addressType = 'Home';
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final addr = widget.addressToEdit;
    _nameController = TextEditingController(text: addr?.recipientName ?? 'Sugu Maran');
    _phoneController = TextEditingController(text: addr?.phoneNumber ?? '9876543210');
    _pincodeController = TextEditingController(text: addr?.postalCode ?? '600001');
    _flatController = TextEditingController(text: addr?.apartment ?? 'Flat 402, Block B');
    _streetController = TextEditingController(text: addr?.streetAddress ?? '12th Main Road, Indiranagar');
    _cityController = TextEditingController(text: addr?.city ?? 'Chennai');
    _addressType = addr?.label ?? 'Home';
    _isDefault = addr?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    _flatController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final addressesProv = context.read<AddressesProvider>();

      if (widget.addressToEdit != null) {
        final updated = widget.addressToEdit!.copyWith(
          recipientName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          streetAddress: _streetController.text.trim(),
          apartment: _flatController.text.trim(),
          city: _cityController.text.trim(),
          postalCode: _pincodeController.text.trim(),
          label: _addressType,
          isDefault: _isDefault,
        );
        addressesProv.updateAddress(updated);
      } else {
        final newAddr = DeliveryAddress(
          id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
          recipientName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          streetAddress: _streetController.text.trim(),
          apartment: _flatController.text.trim(),
          city: _cityController.text.trim(),
          postalCode: _pincodeController.text.trim(),
          label: _addressType,
          isDefault: _isDefault,
        );
        addressesProv.addAddress(newAddr);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.addressToEdit != null
                ? 'Address updated successfully!'
                : 'New address added successfully!',
          ),
          backgroundColor: const Color(0xFF16A34A),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final isEditing = widget.addressToEdit != null;

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

            // Navigation Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppColors.white,
              child: Row(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing ? 'Edit Address' : 'Add New Address',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const Text(
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
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Map Preview Card
                      Container(
                        width: double.infinity,
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=600&auto=format&fit=crop&q=80',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.5)],
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.location_on, color: Color(0xFFEF4444), size: 20),
                                  SizedBox(width: 6),
                                  Text(
                                    'Pinpoint Location on Map',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Change',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Contact Details Card
                      _buildSectionCard(
                        title: 'Contact Details',
                        icon: Icons.person_outline_rounded,
                        children: [
                          _buildTextField(
                            label: 'FULL NAME',
                            hint: 'Enter your full name',
                            controller: _nameController,
                            validator: (val) => val!.trim().isEmpty ? 'Name is required' : null,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            label: 'MOBILE NUMBER',
                            hint: '10-digit mobile number',
                            controller: _phoneController,
                            prefixText: '+91 ',
                            keyboardType: TextInputType.phone,
                            validator: (val) => val!.trim().length < 10 ? 'Enter a valid phone number' : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Address Details Card
                      _buildSectionCard(
                        title: 'Address Details',
                        icon: Icons.home_outlined,
                        children: [
                          _buildTextField(
                            label: 'PINCODE',
                            hint: '6-digit pincode',
                            controller: _pincodeController,
                            keyboardType: TextInputType.number,
                            validator: (val) => val!.trim().isEmpty ? 'Pincode is required' : null,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            label: 'FLAT / HOUSE NO. / APARTMENT',
                            hint: 'e.g. Flat 402, Block B',
                            controller: _flatController,
                            validator: (val) => val!.trim().isEmpty ? 'House/Flat is required' : null,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            label: 'STREET / AREA / LOCALITY',
                            hint: 'e.g. 12th Main Road, Indiranagar',
                            controller: _streetController,
                            validator: (val) => val!.trim().isEmpty ? 'Street area is required' : null,
                          ),
                          const SizedBox(height: 12),
                          _buildTextField(
                            label: 'CITY',
                            hint: 'City',
                            controller: _cityController,
                            validator: (val) => val!.trim().isEmpty ? 'City required' : null,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Address Type Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SAVE ADDRESS AS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF475569),
                                letterSpacing: 0.6,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildTypePill('Home', Icons.home_rounded),
                                const SizedBox(width: 10),
                                _buildTypePill('Work', Icons.work_rounded),
                                const SizedBox(width: 10),
                                _buildTypePill('Other', Icons.location_on_rounded),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Set as default delivery address',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                Switch(
                                  value: _isDefault,
                                  activeThumbColor: AppColors.primary,
                                  onChanged: (val) => setState(() => _isDefault = val),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Fixed Bottom Save Button
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
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Update Address' : 'Save Address & Continue',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    String? prefixText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
            decoration: InputDecoration(
              prefixText: prefixText,
              prefixStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypePill(String type, IconData icon) {
    final isSelected = _addressType.toLowerCase() == type.toLowerCase();
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _addressType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.primary : const Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              Text(
                type,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.primary : const Color(0xFF475569),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
