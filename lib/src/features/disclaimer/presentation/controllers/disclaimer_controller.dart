import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:ai_note/src/features/disclaimer/domain/entities/disclaimer_type.dart';
import 'package:ai_note/src/features/disclaimer/domain/repositories/disclaimer_repository.dart';

class DisclaimerController extends ChangeNotifier {
  DisclaimerController({
    required DisclaimerRepository repository,
  }) : _repository = repository;

  final DisclaimerRepository _repository;
  final Map<DisclaimerType, bool> _cache = {};

  Future<bool> isAccepted(DisclaimerType type) async {
    if (_cache.containsKey(type)) {
      return _cache[type]!;
    }
    final accepted = await _repository.isAccepted(type);
    _cache[type] = accepted;
    return accepted;
  }

  Future<void> markAccepted(DisclaimerType type) async {
    await _repository.markAccepted(type);
    final alreadyAccepted = _cache[type] == true;
    _cache[type] = true;
    if (!alreadyAccepted) {
      notifyListeners();
    }
  }
}
