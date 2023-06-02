import 'dart:io';
import 'package:love_and_care/domain/auth/user_model.dart';
import 'dart:convert';
import 'package:love_and_care/infrastructure/auth/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../response.dart';

class UserDataProvider implements UserRepository {
  final String loggedInUserKey = 'loggedInUser';
  final String tokenKey = 'x-auth-token';

  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);

    final headers = {
      'Content-Type': 'application/json',
      tokenKey: token ?? '',
    };
    return headers;
  }

  @override
  Future<Response<User>> registerUser(
      String username, String email, String password, String role) async {
    final url = Uri.parse('$apiUrl/users/register');
    try {
      final httpClient = HttpClient();
      final request = await httpClient.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        "role": role
      }));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final registeredUser = User.fromJson(responseData);

        final prefs = await SharedPreferences.getInstance();

        prefs.setString(loggedInUserKey, jsonEncode(registeredUser.toJson()));
        prefs.setString(tokenKey, registeredUser.token);

        return Response.success(registeredUser);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to register user';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<User?>> loginUser(String email, String password) async {
    final url = Uri.parse('$apiUrl/users/login');
    try {
      final httpClient = HttpClient();
      final request = await httpClient.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode({'email': email, 'password': password}));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final registeredUser = User.fromJson(responseData);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString(loggedInUserKey, jsonEncode(registeredUser.toJson()));
        prefs.setString(tokenKey, registeredUser.token);

        return Response.success(registeredUser);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to register user';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<String>> logoutUser() async {
    final url = Uri.parse('$apiUrl/users/logout');

    try {
      final httpClient = HttpClient();
      final request = await httpClient.postUrl(url);
      request.headers.contentType = ContentType.json;

      final response = await request.close();
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove(loggedInUserKey);
        prefs.remove(tokenKey);

        return Response.success("log out success");
      } else {
        return Response.error("Failed to log out");
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<User?>> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(loggedInUserKey);

    if (userJson != null) {
      final userData = jsonDecode(userJson);
      return Response.success(User.fromJson(userData));
    }

    return Response.error("Failed to get logged in user");
  }

  @override
  Future<Response<User?>> updateUser(User user) async {
    final url = Uri.parse('$apiUrl/users/${user.userId}');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.putUrl(url);
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final body = jsonEncode({
        "phoneNumber": user.phoneNumber,
        "address": user.address,
        "skills": user.skills,
        "interests": user.interests,
        "about": user.about,
      });
      request.write(body);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final user = User.fromJson(responseData);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString(loggedInUserKey, jsonEncode(user.toJson()));
        prefs.setString(tokenKey, user.token);

        return Response.success(user);
      } else {
        final errorMessage = responseData['message'] ?? 'Failed to Update User';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<User?>> getUser(String username) async {
    final url = Uri.parse('$apiUrl/users/$username');

    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(url);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final user = User.fromJson(responseData);
        return Response.success(user);
      } else {
        final errorMessage = responseData['message'] ?? 'Failed to get User';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }
}
