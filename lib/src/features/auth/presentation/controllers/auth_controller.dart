import 'package:Vairoo/src/core/network/api_client.dart';
import 'package:Vairoo/src/features/auth/domain/entities/auth_session.dart';
import 'package:Vairoo/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:Vairoo/src/features/profile/domain/repositories/profile_repository.dart';
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
  AuthController({
    required AuthRepository repository,
    required ApiClient apiClient,
    required ProfileRepository profileRepository,
    bool useApi = false,
  }) : _repository = repository,
       _apiClient = apiClient,
       _profileRepository = profileRepository,
       _useApi = useApi;

  final AuthRepository _repository;
  final ApiClient _apiClient;
  final ProfileRepository _profileRepository;
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
        _applySession(existing);
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

  Future<void> requestSmsCode() async {
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
        await _repository.requestSmsOtp(phoneNumber: _phoneNumber);
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      }
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
        _applySession(session);
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 400));
        _applySession(
          AuthSession(
            accessToken: 'local-access-token',
            phoneNumber: _phoneNumber,
          ),
        );
      }
      _errorMessage = null;
      _birthDate = null;
      _habitSpending = null;
      if (_session?.isNewUser ?? false) {
        _step = AuthStep.birthdateInput;
      } else {
        _finishOnboarding();
      }
    } catch (error) {
      _setError(_mapError(error));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> completeBirthdate(DateTime? date) async {
    if (date != null && _useApi) {
      _setLoading(true);
      _setError(null);
      try {
        await _profileRepository.updateBirthdate(date);
        _birthDate = date;
      } catch (error) {
        _setError(_mapError(error));
        return;
      } finally {
        _setLoading(false);
      }
    } else {
      _birthDate = date;
    }
    _errorMessage = null;
    _step = AuthStep.goalInput;
    notifyListeners();
  }

  Future<void> completeGoal(String goal) async {
    final needsRemote = _useApi;
    if (needsRemote) {
      _setLoading(true);
      _setError(null);
      try {
        await _profileRepository.updateGoal(goal);
      } catch (error) {
        _setError(_mapError(error));
        return;
      } finally {
        _setLoading(false);
      }
    }
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

  Future<void> completeHabitSpending(String spending) async {
    final normalized = spending.replaceAll(',', '.');
    final parsed = double.tryParse(normalized);
    if (parsed == null) {
      _errorMessage = 'Введите корректную сумму';
      notifyListeners();
      return;
    }
    final needsRemote = _useApi;
    if (needsRemote) {
      _setLoading(true);
      _setError(null);
      try {
        await _profileRepository.updateHabitSpending(parsed);
      } catch (error) {
        _setError(_mapError(error));
        return;
      } finally {
        _setLoading(false);
      }
    }
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

  void _applySession(AuthSession session) {
    _session = session;
    _phoneNumber = session.phoneNumber;
    _apiClient.setAuthToken(session.accessToken, tokenType: session.tokenType);
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

  Future<void> logout() async {
    await _repository.clearSession();
    await _profileRepository.clearProfile();
    _apiClient.setAuthToken(null);
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
        final message = data['detail'] ?? data['message'] ?? data['error'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
      return error.message ?? 'Не удалось выполнить запрос';
    }
    return error.toString();
  }
}
