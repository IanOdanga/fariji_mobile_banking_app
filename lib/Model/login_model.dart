class Login {
  final String login;
  final String pin;


  Login(this.login, this.pin);

  Login.fromJson(Map<String, dynamic> json)
      : login = json['login'],
        pin = json['CloudPESA Pin'];


}