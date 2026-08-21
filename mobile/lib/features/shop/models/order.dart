import 'address.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'product.dart';

enum OrderStatus {
  placed,
  confirmed,
  processing,
  inTransit,
  outForDelivery,
  delivered,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get badgeBgColor {
    switch (this) {
      case OrderStatus.delivered:
        return AppColors.successLight;
      case OrderStatus.inTransit:
      case OrderStatus.outForDelivery:
        return AppColors.inTransitLight;
      case OrderStatus.processing:
      case OrderStatus.placed:
      case OrderStatus.confirmed:
        return AppColors.warningLight;
      case OrderStatus.cancelled:
        return AppColors.dangerLight;
    }
  }

  Color get badgeTextColor {
    switch (this) {
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.inTransit:
      case OrderStatus.outForDelivery:
        return AppColors.inTransitBlue;
      case OrderStatus.processing:
      case OrderStatus.placed:
      case OrderStatus.confirmed:
        return const Color(0xFFD97706);
      case OrderStatus.cancelled:
        return AppColors.danger;
    }
  }
}

class OrderItem {
  final Product product;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.product,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;
}

class TrackingStep {
  final String title;
  final String description;
  final String time;
  final bool isCompleted;
  final bool isCurrent;

  const TrackingStep({
    required this.title,
    required this.description,
    required this.time,
    required this.isCompleted,
    this.isCurrent = false,
  });
}

class CourierInfo {
  final String name;
  final String courierService;
  final String trackingId;
  final String driverName;
  final String driverPhone;
  final double driverRating;
  final int totalDeliveries;
  final String vehicleInfo;
  final String lastUpdated;

  const CourierInfo({
    this.name = 'Aura Express',
    this.courierService = 'Aura Express',
    this.trackingId = 'AE-23981782',
    this.driverName = 'Alex River',
    this.driverPhone = '+1 (555) 234-5678',
    this.driverRating = 4.9,
    this.totalDeliveries = 1240,
    this.vehicleInfo = 'Yamaha E-Bike • NY-892',
    this.lastUpdated = '5 mins ago',
  });
}

class Order {
  final String id;
  final String orderNumber;
  final String invoiceNumber;
  final DateTime createdAt;
  final OrderStatus status;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double tax;
  final double total;
  final DeliveryAddress address;
  final String paymentMethod;
  final String estimatedDelivery;
  final List<TrackingStep> trackingSteps;
  final CourierInfo courier;

  const Order({
    required this.id,
    required this.orderNumber,
    String? invoiceNumber,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    this.tax = 18.0,
    required this.total,
    required this.address,
    required this.paymentMethod,
    required this.estimatedDelivery,
    required this.trackingSteps,
    this.courier = const CourierInfo(),
  }) : invoiceNumber = invoiceNumber ?? 'INV-$orderNumber';
}
