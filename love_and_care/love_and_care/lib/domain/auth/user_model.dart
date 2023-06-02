import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String username;
  final String email;
  final String role;
  final String token;
  final String phoneNumber;
  final String address;
  final String interests;
  final String about;
  final String skills;

  // Add other fields as needed

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    required this.token,
    required this.phoneNumber,
    required this.address,
    required this.interests,
    required this.about,
    required this.skills,

    // Initialize other fields as needed
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['id'] as String,
      username: json['username'] as String,
      token: json['token'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String,
      address: json['address'] as String,
      interests: json['interests'] as String,
      about: json['about'] as String,
      skills: json['skills'] as String,

      // Initialize other fields as needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'username': username,
      'token': token,
      'email': email,
      'role': role,
      'skills': skills,
      'about': about,
      'interests': interests,
      'address': address,
      'phoneNumber': phoneNumber,

      // Add other fields as needed
    };
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        token,
        email,
        role,
        skills,
        interests,
        phoneNumber,
        address,
        about
      ];
}
