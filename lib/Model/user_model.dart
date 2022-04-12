class UserModel {
  late String agent_code;
  late String agent_name;
  late String Telephone;
}

class UserInfoResponse{
  late String? agent_code;
  late String? agent_name;
  late DateTime? Telephone;

  UserInfoResponse({this.agent_code, this.agent_name, this.Telephone});

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    return UserInfoResponse(
      agent_code: json["agent_code"] != null ? json["agent_code"] : "",
      agent_name: json["agent_name"] != null ? json["agent_name"] : "",
      Telephone: json["Telephone"] != null ? json["Telephone"] : "",
    );
  }
}
