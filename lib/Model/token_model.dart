class TokenModel {
  late String token;
}

class TokenModelResponse{
  late String? token;

  TokenModelResponse({this.token});

  factory TokenModelResponse.fromJson(Map<String, dynamic> json) {
    return TokenModelResponse(
      token: json["token"] != null ? json["token"] : ""
    );
  }
}
