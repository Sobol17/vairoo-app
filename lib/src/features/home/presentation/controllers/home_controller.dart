import 'package:ai_note/src/features/home/data/datasources/mock_data.dart';
import 'package:ai_note/src/features/home/domain/entities/home_data.dart';
import 'package:ai_note/src/features/home/domain/entities/home_plan.dart';
import 'package:ai_note/src/features/home/domain/repositories/home_repository.dart';
import 'package:ai_note/src/shared/helpers/formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  HomeController({required HomeRepository repository})
    : _repository = repository;

  final HomeRepository _repository;
  final Formatter _formatter = Formatter();

  static const _fallbackCover =
      'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=800&q=80';

  bool _isLoading = false;
  HomeData? _data;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  HomeData? get data => _data;
  String? get errorMessage => _errorMessage;

  String get quote =>
      _data?.quote.text ??
      'Сложнее всего начать действовать, все остальное зависит от упорства';

  String get sobrietyCounter {
    final start = _data?.sobriety.startDate;
    if (start == null) {
      return '0д 0ч 0мин';
    }
    final diff = DateTime.now().difference(DateTime(
      start.year,
      start.month,
      start.day,
      start.hour,
      start.minute,
      start.second,
    ));
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    return '${days}д ${hours}ч ${minutes}мин';
  }

  String get sobrietyStartLabel {
    final sobriety = _data?.sobriety;
    if (sobriety == null) {
      return 'Дата начала —';
    }
    return 'Дата начала ${_formatter.formatFullDate(sobriety.startDate)}';
  }

  String get dayLabel => _data != null ? '${_data!.dayNumber} День' : '1 День';

  DateTime get planDate => _data?.date ?? DateTime.now();

  List<HomeRoutinePlan> get routines {
    final plans = _data?.plan;
    if (plans == null || plans.isEmpty) {
      return mockRoutines;
    }
    return plans.map(_mapPlan).toList(growable: false);
  }

  Future<void> loadHome() async {
    _setLoading(true);
    try {
      final response = await _repository.fetchHomeData();
      _data = response;
      _errorMessage = null;
    } catch (error) {
      _errorMessage = _mapError(error);
    } finally {
      _setLoading(false);
    }
  }

  HomeRoutinePlan _mapPlan(HomePlanEntry plan) {
    final tagLabel = plan.tags.isNotEmpty
        ? plan.tags.first
        : plan.subtitle.isNotEmpty
        ? plan.subtitle
        : 'План дня';
    return HomeRoutinePlan(
      id: plan.id,
      title: plan.title,
      tagLabel: tagLabel,
      coverImageUrl: plan.coverImageUrl ?? _fallbackCover,
      steps: plan.checklist.isNotEmpty
          ? plan.checklist
          : const ['Поставьте цель, завершите ритуал'],
    );
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
      return error.message ?? 'Не удалось загрузить главный экран';
    }
    return error.toString();
  }
}
