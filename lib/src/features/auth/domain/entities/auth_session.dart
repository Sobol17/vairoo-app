import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.accessToken,
    required this.phoneNumber,
    this.tokenType = 'bearer',
    this.isNewUser = false,
  });

  final String accessToken;
  final String tokenType;
  final String phoneNumber;
  final bool isNewUser;

  @override
  List<Object> get props => [accessToken, tokenType, phoneNumber, isNewUser];
}
