import 'package:pos/models/account.dart';
import 'package:pos/models/user_type.dart';

class User {
  int id;
  String username;
  String password;
  String firstName;
  String lastName;
  String email;
  Account? account;
  UserType? userType;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.account,
    required this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      password: json['password'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      account: json['account'] == '' || json['account'] == null
          ? null
          : Account.fromJson(json['account']),
      userType: json['user_type'] == '' || json['account'] == null
          ? null
          : UserType.fromJson(json['user_type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'account': account?.toJson(),
      'user_type': userType?.toJson(),
    };
  }
}
