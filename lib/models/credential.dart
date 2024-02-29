class LoginCredentials {
  final String username;
  final String password;

  LoginCredentials(this.username, this.password);

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class AccessCredentials {
  final String refresh;
  final String access;

  AccessCredentials({required this.refresh, required this.access});

  factory AccessCredentials.fromJson(Map<String, dynamic> json) {
    return AccessCredentials(
      refresh: json['refresh'] as String,
      access: json['access'] as String,
    );
  }
}
