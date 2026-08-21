import 'package:flutter/material.dart';

class CreditCardPreview extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cardBrand;

  const CreditCardPreview({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    this.cardBrand = 'VISA',
  });

  @override
  Widget build(BuildContext context) {
    final displayCardNumber = cardNumber.isEmpty
        ? '•••• •••• •••• ••••'
        : cardNumber;
    final displayHolder = cardHolder.isEmpty ? 'CARDHOLDER NAME' : cardHolder.toUpperCase();
    final displayExpiry = expiryDate.isEmpty ? 'MM/YY' : expiryDate;

    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A8A), // Deep Indigo Blue
            Color(0xFF2563EB), // Vibrant Royal Blue
            Color(0xFF3B82F6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Chip & Contactless / Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gold Chip Graphic
              Container(
                width: 42,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFDE047), Color(0xFFEAB308), Color(0xFFCA8A04)],
                  ),
                  border: Border.all(color: const Color(0xFFB45309), width: 0.5),
                ),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF78350F).withValues(alpha: 0.4), width: 0.75),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const Icon(
                Icons.contactless_rounded,
                size: 24,
                color: Colors.white70,
              ),
            ],
          ),

          // Card Number
          Text(
            displayCardNumber,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2.2,
              fontFamily: 'Inter',
              shadows: [
                Shadow(
                  color: Colors.black38,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),

          // Bottom Row: Cardholder & Expiry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CARD HOLDER',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        letterSpacing: 0.8,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayHolder,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPIRES',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 0.8,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    displayExpiry,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Brand
              Text(
                cardBrand.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.0,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
