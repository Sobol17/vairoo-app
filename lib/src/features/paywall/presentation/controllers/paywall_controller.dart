import 'package:Vairoo/src/features/paywall/domain/entities/checkout_link.dart';
import 'package:Vairoo/src/features/paywall/domain/repositories/paywall_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PaywallController extends ChangeNotifier {
  PaywallController({required PaywallRepository repository})
    : _repository = repository;

  final PaywallRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<CheckoutLink?> requestCheckoutLink() async {
    if (_isLoading) {
      return null;
    }
    _setLoading(true);
    _setError(null);
    try {
      final link = await _repository.createCheckoutLink();
      return link;
    } catch (error) {
      _setError(_mapError(error));
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading == value) {
      return;
    }
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    if (_errorMessage == message) {
      return;
    }
    _errorMessage = message;
    notifyListeners();
  }

  String _mapError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['detail'] ?? data['message'] ?? data['error'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
      return error.message ?? 'Не удалось создать ссылку на оплату';
    }
    return error.toString();
  }
}
