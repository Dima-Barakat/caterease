import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  static Future<void> initialize() async {
    // Configure Stripe
    Stripe.publishableKey =
        'pk_test_51Rs9chA6EqmL0yVtkuAsO4IIncUegpjGYhxLbB90PVbSRGOYxy5QHboAMlIoyIR3MIvQubn0o2YLl41VjeHI93rh00scxoyJuR';
    Stripe.merchantIdentifier = 'merchant.flutter.stripe';
    Stripe.urlScheme = 'flutterstripe';

    await Stripe.instance.applySettings();
  }
}
