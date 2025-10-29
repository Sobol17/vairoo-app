import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:ai_note/src/features/auth/domain/entities/auth_session.dart';
import 'package:ai_note/src/features/auth/domain/repositories/auth_repository.dart';

enum AuthStep {
  phoneInput,
  otpInput,
  authenticated,
}

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthRepository repository,
  }) : _repository = repository;

  final AuthRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  AuthStep _step = AuthStep.phoneInput;
  String _phoneNumber = '';
  AuthSession? _session;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthStep get step => _step;
  String get phoneNumber => _phoneNumber;
  AuthSession? get session => _session;
  bool get isAuthenticated => _step == AuthStep.authenticated;

  Future<void> restoreSession() async {
    try {
      final existing = await _repository.loadSession();
      if (existing != null) {
        _session = existing;
        _phoneNumber = existing.phoneNumber;
        _step = AuthStep.authenticated;
        notifyListeners();
      }
    } catch (_) {
      // Ignore persistence errors and force user to re-authenticate.
    }
  }

  Future<void> submitPhone(String phoneNumber) async {
    final normalized = phoneNumber.trim();
    if (normalized.isEmpty) {
      _errorMessage = 'Введите номер телефона';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      await _repository.requestOtp(phoneNumber: normalized);
      _phoneNumber = normalized;
      _step = AuthStep.otpInput;
    } catch (error) {
      _setError(_mapError(error));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> submitCode(String code) async {
    final normalized = code.trim();
    if (normalized.isEmpty) {
      _errorMessage = 'Введите код из SMS';
      notifyListeners();
      return;
    }

    if (_phoneNumber.isEmpty) {
      _errorMessage = 'Сначала отправьте номер телефона';
      _step = AuthStep.phoneInput;
      notifyListeners();
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      final session = await _repository.verifyOtp(
        phoneNumber: _phoneNumber,
        code: normalized,
      );
      _session = session;
      _step = AuthStep.authenticated;
    } catch (error) {
      _setError(_mapError(error));
    } finally {
      _setLoading(false);
    }
  }

  void reset() {
    final shouldNotify = _phoneNumber.isNotEmpty ||
        _session != null ||
        _step != AuthStep.phoneInput ||
        _errorMessage != null;

    _phoneNumber = '';
    _session = null;
    _step = AuthStep.phoneInput;
    _errorMessage = null;

    if (shouldNotify) {
      notifyListeners();
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
        final message = data['message'] ?? data['error'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
      return error.message ?? 'Не удалось выполнить запрос';
    }
    return error.toString();
  }
}
