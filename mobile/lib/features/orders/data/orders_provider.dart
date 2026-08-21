import 'package:flutter/foundation.dart';
import '../../shop/models/address.dart';
import '../../shop/models/order.dart';
import '../../shop/data/shop_data.dart';

class OrdersProvider extends ChangeNotifier {
  final List<Order> _orders = List.from(ShopData.sampleOrders);

  List<Order> get orders => List.unmodifiable(_orders);

  List<Order> get activeOrders =>
      _orders.where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled).toList();

  List<Order> get completedOrders =>
      _orders.where((o) => o.status == OrderStatus.delivered).toList();

  List<Order> get cancelledOrders =>
      _orders.where((o) => o.status == OrderStatus.cancelled).toList();

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere(
        (o) => o.id == id || o.orderNumber == id || o.invoiceNumber == id,
      );
    } catch (_) {
      return null;
    }
  }

  Order createOrder({
    required List<OrderItem> items,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required double total,
    required DeliveryAddress address,
    required String paymentMethod,
  }) {
    final newOrder = Order(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: 'GRZ-${(10000 + _orders.length + 1)}',
      createdAt: DateTime.now(),
      status: OrderStatus.placed,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      address: address,
      paymentMethod: paymentMethod,
      estimatedDelivery: 'Today, within 25-35 mins',
      trackingSteps: [
        TrackingStep(
          title: 'Order Placed',
          description: 'Payment verified and order confirmed',
          time: 'Just now',
          isCompleted: true,
          isCurrent: true,
        ),
        const TrackingStep(
          title: 'Items Packing',
          description: 'Grocery store preparing your items',
          time: 'Next up',
          isCompleted: false,
        ),
        const TrackingStep(
          title: 'Out for Delivery',
          description: 'Courier assigned and en route',
          time: 'Pending',
          isCompleted: false,
        ),
        const TrackingStep(
          title: 'Delivered',
          description: 'Package arrives at your door',
          time: 'Estimated ~30 mins',
          isCompleted: false,
        ),
      ],
    );

    _orders.insert(0, newOrder);
    notifyListeners();
    return newOrder;
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final current = _orders[index];
      _orders[index] = Order(
        id: current.id,
        orderNumber: current.orderNumber,
        createdAt: current.createdAt,
        status: OrderStatus.cancelled,
        items: current.items,
        subtotal: current.subtotal,
        deliveryFee: current.deliveryFee,
        discount: current.discount,
        total: current.total,
        address: current.address,
        paymentMethod: current.paymentMethod,
        estimatedDelivery: 'Cancelled',
        trackingSteps: [
          TrackingStep(
            title: 'Order Cancelled',
            description: 'Order was cancelled by user',
            time: 'Just now',
            isCompleted: true,
            isCurrent: true,
          ),
        ],
      );
      notifyListeners();
    }
  }
}
