import 'dart:convert';

import 'package:ai_note/src/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.accessToken,
    required super.phoneNumber,
    super.tokenType = 'bearer',
    super.isNewUser = false,
  });

  factory AuthSessionModel.fromSession(AuthSession session) => AuthSessionModel(
    accessToken: session.accessToken,
    phoneNumber: session.phoneNumber,
    tokenType: session.tokenType,
    isNewUser: session.isNewUser,
  );

  factory AuthSessionModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackPhoneNumber,
  }) {
    final token =
        (json['access_token'] ?? json['accessToken'] ?? json['token'])
            as String?;
    final phone =
        (json['phone'] ??
                json['phoneNumber'] ??
                json['phone_number'] ??
                fallbackPhoneNumber)
            as String?;
    if (token == null || phone == null) {
      throw const FormatException('Invalid auth session payload');
    }
    return AuthSessionModel(
      accessToken: token,
      phoneNumber: phone,
      tokenType:
          ((json['token_type'] ?? json['tokenType']) as String?) ?? 'bearer',
      isNewUser: ((json['is_new_user'] ?? json['isNewUser']) as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'tokenType': tokenType,
    'phoneNumber': phoneNumber,
    'isNewUser': isNewUser,
  };

  String toJsonString() => jsonEncode(toJson());

  static AuthSessionModel fromJsonString(String source) {
    return AuthSessionModel.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }
}
