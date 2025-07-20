import 'user_model.dart';

class SignInResponse {
  final String message;
  final String jwt;
  final User user;

  SignInResponse({
    required this.message,
    required this.jwt,
    required this.user,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      message: json['message'],
      jwt: json['jwt'],
      user: User.fromJson(json['user']),
    );
  }
}
