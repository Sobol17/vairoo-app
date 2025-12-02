import 'package:Vairoo/src/features/paywall/domain/entities/checkout_link.dart';

abstract class PaywallRepository {
  Future<CheckoutLink> createCheckoutLink();
}
