import 'package:Vairoo/src/features/paywall/domain/entities/checkout_link.dart';

class CheckoutLinkModel extends CheckoutLink {
  const CheckoutLinkModel({
    required super.paymentId,
    required super.paymentUrl,
  });

  factory CheckoutLinkModel.fromJson(Map<String, dynamic> json) {
    final paymentId =
        (json['payment_id'] ?? json['paymentId'] ?? '').toString();
    final paymentUrl =
        (json['payment_url'] ?? json['paymentUrl'] ?? '').toString();
    if (paymentUrl.isEmpty) {
      throw const FormatException('Missing payment_url');
    }
    return CheckoutLinkModel(paymentId: paymentId, paymentUrl: paymentUrl);
  }
}
