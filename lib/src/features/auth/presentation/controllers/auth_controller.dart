import 'package:ai_note/src/features/auth/domain/entities/auth_session.dart';
import 'package:ai_note/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum AuthStep {
  welcome,
  phoneInput,
  otpInput,
  birthdateInput,
  goalInput,
  paymentInput,
  habitSpendingInput,
  authenticated,
}

class AuthController extends ChangeNotifier {
  AuthController({required AuthRepository repository, bool useApi = false})
    : _repository = repository,
      _useApi = useApi;

  final AuthRepository _repository;
  final bool _useApi;

  bool _isLoading = false;
  String? _errorMessage;
  AuthStep _step = AuthStep.welcome;
  String _phoneNumber = '';
  AuthSession? _session;
  DateTime? _birthDate;
  String? _goal;
  String? _habitSpending;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthStep get step => _step;
  String get phoneNumber => _phoneNumber;
  AuthSession? get session => _session;
  DateTime? get birthDate => _birthDate;
  String? get goal => _goal;
  String? get habitSpending => _habitSpending;
  bool get isAuthenticated => _step == AuthStep.authenticated;

  Future<void> restoreSession() async {
    if (!_useApi) {
      return;
    }
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

  void goToWelcome() {
    if (_step == AuthStep.welcome) {
      return;
    }
    _errorMessage = null;
    _step = AuthStep.welcome;
    notifyListeners();
  }

  void showPhoneInput({bool clearPhone = false}) {
    final wasDifferentStep = _step != AuthStep.phoneInput;
    final hadError = _errorMessage != null;
    if (clearPhone) {
      _phoneNumber = '';
    }
    _session = null;
    _birthDate = null;
    _goal = null;
    _habitSpending = null;
    _step = AuthStep.phoneInput;
    _errorMessage = null;
    if (wasDifferentStep || hadError || clearPhone) {
      notifyListeners();
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
      if (_useApi) {
        await _repository.requestOtp(phoneNumber: normalized);
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      }
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
      if (_useApi) {
        final session = await _repository.verifyOtp(
          phoneNumber: _phoneNumber,
          code: normalized,
        );
        _session = session;
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 400));
        _session = AuthSession(
          accessToken: 'local-access-token',
          refreshToken: 'local-refresh-token',
          phoneNumber: _phoneNumber,
        );
      }
      _errorMessage = null;
      _birthDate = null;
      _habitSpending = null;
      _step = AuthStep.birthdateInput;
    } catch (error) {
      _setError(_mapError(error));
    } finally {
      _setLoading(false);
    }
  }

  void completeBirthdate(DateTime? date) {
    _birthDate = date;
    _errorMessage = null;
    _step = AuthStep.goalInput;
    notifyListeners();
  }

  void completeGoal(String goal) {
    _goal = goal;
    _errorMessage = null;
    _step = AuthStep.paymentInput;
    notifyListeners();
  }

  void completePayment() {
    _errorMessage = null;
    _step = AuthStep.habitSpendingInput;
    notifyListeners();
  }

  void completeHabitSpending(String spending) {
    _habitSpending = spending;
    _finishOnboarding();
  }

  void skipHabitSpending() {
    _habitSpending = null;
    _finishOnboarding();
  }

  void _finishOnboarding() {
    _errorMessage = null;
    _step = AuthStep.authenticated;
    notifyListeners();
  }

  void backToOtp() {
    if (_step == AuthStep.birthdateInput) {
      _errorMessage = null;
      _step = AuthStep.otpInput;
      notifyListeners();
    }
  }

  void backToBirthdate() {
    if (_step == AuthStep.goalInput) {
      _errorMessage = null;
      _step = AuthStep.birthdateInput;
      _goal = null;
      notifyListeners();
    }
  }

  void backToGoal() {
    if (_step == AuthStep.paymentInput) {
      _errorMessage = null;
      _step = AuthStep.goalInput;
      notifyListeners();
    }
  }

  void backToPayment() {
    if (_step == AuthStep.habitSpendingInput) {
      _errorMessage = null;
      _step = AuthStep.paymentInput;
      notifyListeners();
    }
  }

  void reset() {
    showPhoneInput(clearPhone: true);
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
