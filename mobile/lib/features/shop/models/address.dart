class DeliveryAddress {
  final String id;
  final String label; // "Home", "Work", "Other"
  final String recipientName;
  final String phoneNumber;
  final String streetAddress;
  final String apartment;
  final String city;
  final String postalCode;
  final bool isDefault;

  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.recipientName,
    required this.phoneNumber,
    required this.streetAddress,
    this.apartment = '',
    required this.city,
    required this.postalCode,
    this.isDefault = false,
  });

  String get fullAddress {
    final apt = apartment.isNotEmpty ? '$apartment, ' : '';
    return '$apt$streetAddress, $city - $postalCode';
  }

  DeliveryAddress copyWith({
    String? id,
    String? label,
    String? recipientName,
    String? phoneNumber,
    String? streetAddress,
    String? apartment,
    String? city,
    String? postalCode,
    bool? isDefault,
  }) {
    return DeliveryAddress(
      id: id ?? this.id,
      label: label ?? this.label,
      recipientName: recipientName ?? this.recipientName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      streetAddress: streetAddress ?? this.streetAddress,
      apartment: apartment ?? this.apartment,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
