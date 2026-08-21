import 'package:go_router/go_router.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/presentation/create_account_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/splash/presentation/splash_animation_screen.dart';
import '../../features/shell/presentation/main_shell_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/product/presentation/product_details_screen.dart';
import '../../features/checkout/presentation/checkout_address_screen.dart';
import '../../features/checkout/presentation/add_edit_address_screen.dart';
import '../../features/checkout/presentation/checkout_payment_screen.dart';
import '../../features/checkout/presentation/add_new_card_screen.dart';
import '../../features/checkout/presentation/checkout_review_screen.dart';
import '../../features/checkout/presentation/order_success_screen.dart';
import '../../features/checkout/presentation/coupons_offers_screen.dart';
import '../../features/orders/presentation/order_history_screen.dart';
import '../../features/orders/presentation/order_details_screen.dart';
import '../../features/orders/presentation/track_order_screen.dart';
import '../../features/orders/presentation/live_tracking_screen.dart';
import '../../features/orders/presentation/order_invoice_screen.dart';
import '../../features/orders/presentation/order_tracking_screen.dart';
import '../../features/profile/presentation/saved_addresses_screen.dart';
import '../../features/profile/presentation/language_screen.dart';
import '../../features/profile/presentation/about_screen.dart';
import '../../features/profile/presentation/shipping_preferences_screen.dart';
import '../../features/profile/presentation/contact_us_screen.dart';
import '../../features/profile/presentation/privacy_security_screen.dart';
import '../../features/profile/presentation/help_center_screen.dart';
import '../../features/wishlist/presentation/wishlist_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/profile/presentation/faq_details_screen.dart';
import '../../features/profile/presentation/notification_preferences_screen.dart';
import '../../features/stores/presentation/store_locator_screen.dart';
import '../../features/stores/presentation/store_details_screen.dart';
import '../../features/support/presentation/live_chat_screen.dart';
import '../../features/shop/models/product.dart';
import '../../features/shop/models/address.dart';
import '../../features/shop/models/order.dart';

GoRouter createAppRouter({
  required AppSession session,
  required AuthRepository authRepository,
}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashAnimationScreen(
          onFinished: () async {
            final user = await authRepository.getCurrentUser();
            if (user != null && user.isVerified) return '/home';
            if (session.onboardingCompleted) return '/sign-in';
            return '/onboarding';
          },
        ),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) {
          session.setOnboardingCompleted();
          return const OnboardingScreen();
        },
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/create-account',
        builder: (context, state) => const CreateAccountScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainShellScreen(initialIndex: 0),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const MainShellScreen(initialIndex: 1),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? (state.extra as String?);
          if (query != null && query.isNotEmpty) {
            return SearchScreen(initialQuery: query, showBottomNav: true);
          }
          return const MainShellScreen(initialIndex: 2);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const MainShellScreen(initialIndex: 3),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const MainShellScreen(initialIndex: 4),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => const WishlistScreen(),
      ),
      GoRoute(
        path: '/product-details',
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: '/checkout/coupons',
        builder: (context, state) => const CouponsOffersScreen(),
      ),
      GoRoute(
        path: '/checkout/address',
        builder: (context, state) => const CheckoutAddressScreen(),
      ),
      GoRoute(
        path: '/checkout/address/add',
        builder: (context, state) => const AddEditAddressScreen(),
      ),
      GoRoute(
        path: '/checkout/address/edit',
        builder: (context, state) {
          final address = state.extra as DeliveryAddress?;
          return AddEditAddressScreen(addressToEdit: address);
        },
      ),
      GoRoute(
        path: '/checkout/payment',
        builder: (context, state) {
          final address = state.extra as DeliveryAddress?;
          return CheckoutPaymentScreen(address: address);
        },
      ),
      GoRoute(
        path: '/checkout/payment/add-card',
        builder: (context, state) => const AddNewCardScreen(),
      ),
      GoRoute(
        path: '/checkout/review',
        builder: (context, state) {
          final extraMap = state.extra as Map<String, dynamic>?;
          final address = extraMap?['address'] as DeliveryAddress?;
          final paymentMethod = extraMap?['paymentMethod'] as String?;
          return CheckoutReviewScreen(
            address: address,
            paymentMethod: paymentMethod,
          );
        },
      ),
      GoRoute(
        path: '/order-success',
        builder: (context, state) {
          final order = state.extra as Order?;
          return OrderSuccessScreen(order: order);
        },
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) {
          final tabParam = state.uri.queryParameters['tab'];
          final initialTab = tabParam != null ? int.tryParse(tabParam) ?? 0 : 0;
          return OrderHistoryScreen(initialTabIndex: initialTab);
        },
      ),
      GoRoute(
        path: '/orders/:id',
        builder: (context, state) {
          final orderId = state.pathParameters['id'];
          final order = state.extra as Order?;
          return OrderDetailsScreen(order: order, orderId: orderId);
        },
      ),
      GoRoute(
        path: '/orders/:id/track',
        builder: (context, state) {
          final orderId = state.pathParameters['id'];
          final order = state.extra as Order?;
          return TrackOrderScreen(order: order, orderId: orderId);
        },
      ),
      GoRoute(
        path: '/orders/:id/live-tracking',
        builder: (context, state) {
          final orderId = state.pathParameters['id'];
          final order = state.extra as Order?;
          return LiveTrackingScreen(order: order, orderId: orderId);
        },
      ),
      GoRoute(
        path: '/orders/:id/invoice',
        builder: (context, state) {
          final orderId = state.pathParameters['id'];
          final order = state.extra as Order?;
          return OrderInvoiceScreen(order: order, orderId: orderId);
        },
      ),
      GoRoute(
        path: '/invoice',
        builder: (context, state) {
          final order = state.extra as Order?;
          return OrderInvoiceScreen(order: order);
        },
      ),
      GoRoute(
        path: '/order-tracking',
        builder: (context, state) {
          final order = state.extra as Order?;
          return OrderTrackingScreen(order: order);
        },
      ),
      GoRoute(
        path: '/live-tracking',
        builder: (context, state) {
          final order = state.extra as Order?;
          return LiveTrackingScreen(order: order);
        },
      ),
      GoRoute(
        path: '/profile/addresses',
        builder: (context, state) => const SavedAddressesScreen(),
      ),
      GoRoute(
        path: '/profile/shipping-preferences',
        builder: (context, state) => const ShippingPreferencesScreen(),
      ),
      GoRoute(
        path: '/profile/language',
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/profile/privacy-security',
        builder: (context, state) => const PrivacySecurityScreen(),
      ),
      GoRoute(
        path: '/profile/about',
        builder: (context, state) => const AboutGrozzbyScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/support',
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: '/support/contact',
        builder: (context, state) => const ContactUsScreen(),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactUsScreen(),
      ),
      GoRoute(
        path: '/support/faq',
        builder: (context, state) => const FaqDetailsScreen(),
      ),
      GoRoute(
        path: '/support/orders-shipping',
        builder: (context, state) => const FaqDetailsScreen(),
      ),
      GoRoute(
        path: '/stores',
        builder: (context, state) => const StoreLocatorScreen(),
      ),
      GoRoute(
        path: '/store-locator',
        builder: (context, state) => const StoreLocatorScreen(),
      ),
      GoRoute(
        path: '/stores/:id',
        builder: (context, state) {
          final storeId = state.pathParameters['id'];
          return StoreDetailsScreen(storeId: storeId);
        },
      ),
      GoRoute(
        path: '/support/chat',
        builder: (context, state) => const LiveChatScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const LiveChatScreen(),
      ),
      GoRoute(
        path: '/profile/notification-preferences',
        builder: (context, state) => const NotificationPreferencesScreen(),
      ),
      GoRoute(
        path: '/notifications/preferences',
        builder: (context, state) => const NotificationPreferencesScreen(),
      ),
    ],
  );
}
