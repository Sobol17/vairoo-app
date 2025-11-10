import 'dart:async';

import 'package:ai_note/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionController extends ChangeNotifier {
  NotificationPermissionController({required AuthController authController})
    : _authController = authController {
    _previouslyAuthenticated = _authController.isAuthenticated;
    _authListener = () {
      final isAuthenticated = _authController.isAuthenticated;
      if (isAuthenticated && !_previouslyAuthenticated) {
        _shouldPrompt = true;
        notifyListeners();
        unawaited(_refreshStatus());
      } else if (!isAuthenticated && _previouslyAuthenticated) {
        _shouldPrompt = false;
        notifyListeners();
      }
      _previouslyAuthenticated = isAuthenticated;
    };
    _authController.addListener(_authListener);
    unawaited(_refreshStatus());
  }

  final AuthController _authController;
  late final VoidCallback _authListener;

  PermissionStatus _status = PermissionStatus.denied;
  bool _statusKnown = false;
  bool _isRequesting = false;
  bool _shouldPrompt = false;
  bool _previouslyAuthenticated = false;

  PermissionStatus get status => _status;
  bool get statusKnown => _statusKnown;
  bool get isRequesting => _isRequesting;

  bool get isGranted =>
      _status == PermissionStatus.granted ||
      _status == PermissionStatus.provisional;

  bool get shouldPrompt => statusKnown && _shouldPrompt && !isGranted;

  Future<void> refreshStatus() => _refreshStatus();

  Future<void> requestPermission() async {
    if (_isRequesting) {
      return;
    }
    _setRequesting(true);
    final result = await Permission.notification.request();
    _status = result;
    _statusKnown = true;
    if (isGranted) {
      _shouldPrompt = false;
    }
    _setRequesting(false);
    notifyListeners();
  }

  void deferPrompt() {
    if (!_shouldPrompt) {
      return;
    }
    _shouldPrompt = false;
    notifyListeners();
  }

  Future<void> _refreshStatus() async {
    final result = await Permission.notification.status;
    _status = result;
    _statusKnown = true;
    if (isGranted && _shouldPrompt) {
      _shouldPrompt = false;
    }
    notifyListeners();
  }

  void _setRequesting(bool value) {
    if (_isRequesting == value) {
      return;
    }
    _isRequesting = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authController.removeListener(_authListener);
    super.dispose();
  }
}
