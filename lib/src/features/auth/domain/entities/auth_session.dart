import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.phoneNumber,
  });

  final String accessToken;
  final String refreshToken;
  final String phoneNumber;

  @override
  List<Object> get props => [accessToken, refreshToken, phoneNumber];
}
