import 'package:Vairoo/src/features/plan/domain/entities/daily_plan.dart';
import 'package:Vairoo/src/features/plan/domain/repositories/plan_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PlanController extends ChangeNotifier {
  PlanController({required PlanRepository repository, DailyPlan? initialPlan})
    : _repository = repository,
      _plan = initialPlan,
      _visibleStep = initialPlan?.currentStep,
      _isDayCompleted = initialPlan?.isCompleted ?? false;

  final PlanRepository _repository;

  DailyPlan? _plan;
  bool _isLoading = false;
  String? _errorMessage;
  String? _actionErrorMessage;
  String? _completingItemId;
  bool _canGoNextStep = false;
  bool _isDayCompleted;
  PlanStep? _visibleStep;

  DailyPlan? get plan => _plan;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get actionErrorMessage => _actionErrorMessage;
  bool get hasPlan => _plan != null;
  bool get canGoNextStep => _canGoNextStep;
  bool get isDayCompleted => _isDayCompleted;
  String? get completingItemId => _completingItemId;
  PlanStep get visibleStep =>
      _visibleStep ?? _plan?.currentStep ?? PlanStep.morning;

  Future<void> createOrFetchPlan() {
    return _load(_repository.startPlan);
  }

  Future<void> refreshCurrentPlan() {
    return _load(_repository.fetchCurrentPlan);
  }

  Future<void> completeItem(String itemId) async {
    if (_completingItemId != null) {
      return;
    }
    _completingItemId = itemId;
    _actionErrorMessage = null;
    notifyListeners();
    try {
      final result = await _repository.completeItem(itemId);
      _plan = result.plan;
      _canGoNextStep = result.canGoNextStep;
      _isDayCompleted = result.isDayCompleted;
      _errorMessage = null;
    } catch (error) {
      _actionErrorMessage = _mapError(error);
    } finally {
      _completingItemId = null;
      notifyListeners();
    }
  }

  void clearActionError() {
    if (_actionErrorMessage == null) {
      return;
    }
    _actionErrorMessage = null;
    notifyListeners();
  }

  void showCurrentStep() {
    final current = _plan?.currentStep;
    if (current == null) {
      return;
    }
    final didChange = _visibleStep != current || _canGoNextStep;
    _visibleStep = current;
    _canGoNextStep = false;
    if (didChange) {
      notifyListeners();
    }
  }

  Future<void> _load(
    Future<DailyPlan> Function() loader, {
    bool updateVisibleStep = true,
  }) async {
    _setLoading(true);
    try {
      _plan = await loader();
      _errorMessage = null;
      _actionErrorMessage = null;
      _canGoNextStep = false;
      _isDayCompleted = _plan?.isCompleted ?? false;
      if (updateVisibleStep) {
        _visibleStep = _plan?.currentStep;
      }
    } catch (error) {
      _errorMessage = _mapError(error);
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

  String _mapError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['detail'] ?? data['message'] ?? data['error'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
      return error.message ?? 'Произошла ошибка';
    }
    return error.toString();
  }
}
