import 'dart:convert';

import 'package:ai_note/src/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.accessToken,
    required super.refreshToken,
    required super.phoneNumber,
  });

  factory AuthSessionModel.fromSession(AuthSession session) => AuthSessionModel(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        phoneNumber: session.phoneNumber,
      );

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'phoneNumber': phoneNumber,
      };

  String toJsonString() => jsonEncode(toJson());

  static AuthSessionModel fromJsonString(String source) {
    return AuthSessionModel.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }
}
