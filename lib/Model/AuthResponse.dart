import './user.dart';

class AuthResponse {
  final String token;
  User user;

  AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> parsedJson){
    return AuthResponse(
        token: parsedJson['token'],
        user: User.fromJson(parsedJson['user'])
    );
  }


  Map<String, dynamic> toJson() => {
    'token': token,
    'user':user,
  };
}