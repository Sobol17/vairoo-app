import 'package:Vairoo/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:Vairoo/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SubscriptionController extends ChangeNotifier {
  SubscriptionController({
    required ProfileRepository profileRepository,
    required AuthController authController,
  }) : _profileRepository = profileRepository,
       _authController = authController {
    _authController.addListener(_handleAuthChanged);
    _handleAuthChanged();
  }

  final ProfileRepository _profileRepository;
  final AuthController _authController;

  bool _isChecking = false;
  DateTime? _subscriptionExpiresAt;
  String? _errorMessage;

  bool get isChecking => _isChecking;
  DateTime? get subscriptionExpiresAt => _subscriptionExpiresAt;
  String? get errorMessage => _errorMessage;

  bool get isSubscriptionExpired {
    final expiresAt = _subscriptionExpiresAt;
    if (expiresAt == null) {
      return false;
    }
    return !expiresAt.isAfter(DateTime.now());
  }

  Future<void> refresh() async {
    if (_isChecking || !_authController.isAuthenticated) {
      return;
    }
    _setChecking(true);
    try {
      final profile = await _profileRepository.loadProfile();
      _subscriptionExpiresAt = profile.subscriptionExpiresAt;
      _setError(null);
    } catch (error) {
      _setError(_mapError(error));
    } finally {
      _setChecking(false);
    }
  }

  void _handleAuthChanged() {
    if (_authController.isAuthenticated) {
      refresh();
    } else {
      final hadValue = _subscriptionExpiresAt != null || _errorMessage != null;
      _subscriptionExpiresAt = null;
      _errorMessage = null;
      if (hadValue) {
        notifyListeners();
      }
    }
  }

  void _setChecking(bool value) {
    if (_isChecking == value) {
      return;
    }
    _isChecking = value;
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
      return error.message ?? 'Не удалось получить данные подписки';
    }
    return error.toString();
  }

  @override
  void dispose() {
    _authController.removeListener(_handleAuthChanged);
    super.dispose();
  }
}
