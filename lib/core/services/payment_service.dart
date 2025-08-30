import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  static Future<void> initialize() async {
    // Configure Stripe
    Stripe.publishableKey =
        'pk_test_51RbjJcDHuETbMKMzq5kr6nKxzgIpVDY9UoBz08nLdgZPqLGlKf4R6kYZhEQG4Cf3v5y7RVL9I1zsFclefgWLdbTs00F3s9vmrZ';
    Stripe.merchantIdentifier = 'merchant.flutter.stripe';
    Stripe.urlScheme = 'flutterstripe';

    await Stripe.instance.applySettings();
  }
}
