const ORDERS = [
  {
    id: 'ord_1',
    orderNumber: 'AS-882910',
    invoiceNumber: 'INV-AS-882910',
    createdAt: new Date('2023-10-24T10:45:00Z').toISOString(),
    status: 'in_transit',
    statusLabel: 'In Transit',
    items: [
      {
        id: 'item_1',
        product: {
          id: 'prod_sony_wh1000xm5',
          name: 'SONY WH-1000XM5',
          imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&auto=format&fit=crop&q=80',
          price: 120.0,
          unit: '1 unit (Black Edition)',
        },
        quantity: 1,
        unitPrice: 120.0,
      },
      {
        id: 'item_2',
        product: {
          id: 'prod_fossil_minimalist',
          name: 'FOSSIL Minimalist Watch',
          imageUrl: 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=500&auto=format&fit=crop&q=80',
          price: 120.0,
          unit: '1 unit (Leather Strap)',
        },
        quantity: 1,
        unitPrice: 120.0,
      },
    ],
    subtotal: 240.0,
    deliveryFee: 0.0,
    discount: 40.0,
    tax: 0.0,
    total: 200.0,
    shippingAddress: {
      label: 'Home',
      recipientName: 'Julian Thorne',
      phoneNumber: '+1 (415) 555-0198',
      streetAddress: '842 Aurora Blvd, Suite 4',
      apartment: 'San Francisco, CA 94110, USA',
      city: 'San Francisco',
      postalCode: '94110',
    },
    paymentMethod: 'Visa Platinum (•••• 4242)',
    estimatedDelivery: 'Tomorrow, Oct 28 by Before 8 PM',
    courier: {
      name: 'Grozzby Express',
      courierService: 'Grozzby Express',
      trackingId: 'AE-23981782',
      driverName: 'Marcus Chen',
      driverPhone: '+1 (415) 555-0198',
      driverRating: 4.9,
      totalDeliveries: 1240,
      vehicleInfo: 'Electric Vehicle • Speaks English',
      lastUpdated: '5 mins ago',
    },
    trackingSteps: [
      {
        title: 'Order Confirmed',
        description: 'Payment verified & order created',
        time: 'Oct 24, 10:45 AM',
        isCompleted: true,
      },
      {
        title: 'Processing',
        description: 'Items packed and sealed by store',
        time: 'Oct 24, 02:15 PM',
        isCompleted: true,
      },
      {
        title: 'Shipped',
        description: 'Package handed to courier driver',
        time: 'Oct 25, 08:30 AM',
        isCompleted: true,
      },
      {
        title: 'Out for Delivery',
        description: 'Courier is en route to destination',
        time: 'Oct 26, 09:15 AM',
        isCompleted: false,
        isCurrent: true,
      },
      {
        title: 'Delivered',
        description: 'Package delivered at door',
        time: 'Expected Oct 26, 07:00 PM',
        isCompleted: false,
      },
    ],
  },
];

export async function getOrders(req, res) {
  res.json({
    success: true,
    data: ORDERS,
    total: ORDERS.length,
  });
}

export async function getOrderById(req, res) {
  const { id } = req.params;
  const order = ORDERS.find((o) => o.id === id || o.orderNumber === id);

  if (!order) {
    return res.status(404).json({ success: false, error: 'Order not found' });
  }

  res.json({ success: true, data: order });
}

export async function createOrder(req, res) {
  const { items, address, paymentMethod, total } = req.body;

  const newOrder = {
    id: `ord_${Date.now()}`,
    orderNumber: `AS-${Math.floor(100000 + Math.random() * 900000)}`,
    invoiceNumber: `INV-AS-${Math.floor(100000 + Math.random() * 900000)}`,
    createdAt: new Date().toISOString(),
    status: 'processing',
    statusLabel: 'Processing',
    items: items || [],
    subtotal: total || 0,
    deliveryFee: 0,
    discount: 0,
    tax: 0,
    total: total || 0,
    shippingAddress: address || {},
    paymentMethod: paymentMethod || 'Online Payment',
    estimatedDelivery: 'Within 15-30 Minutes',
    courier: {
      name: 'Grozzby Fast Delivery',
      trackingId: `AE-${Math.floor(1000000 + Math.random() * 9000000)}`,
      lastUpdated: 'Just now',
    },
    trackingSteps: [
      {
        title: 'Order Confirmed',
        description: 'Payment verified',
        time: 'Just now',
        isCompleted: true,
        isCurrent: true,
      },
      {
        title: 'Packing',
        description: 'Store preparing your items',
        time: 'Pending',
        isCompleted: false,
      },
      {
        title: 'Out for Delivery',
        description: 'Rider on the way',
        time: 'Pending',
        isCompleted: false,
      },
      {
        title: 'Delivered',
        description: 'Delivered to your doorstep',
        time: 'Pending',
        isCompleted: false,
      },
    ],
  };

  ORDERS.unshift(newOrder);

  res.status(201).json({
    success: true,
    data: newOrder,
    message: 'Order created successfully',
  });
}
