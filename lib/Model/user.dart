class User {
  final int id;
  final String name;
  final String email;
  final String mobile;
  final int active;
  final String confirmation_code;
  final int confirmed;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.active,
    required this.confirmation_code,
    required this.confirmed,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      active: json['active'],
      confirmation_code: json['confirmation_code'],
      confirmed: json['confirmed'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email':email,
    'mobile':mobile,
    'active':active,
    'confirmation_code':confirmation_code,
    'confirmed':confirmed,
  };
}