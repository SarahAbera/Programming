import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../../domain/comment/comment_model.dart';
import '../response.dart';
import 'comment_repository.dart';
import 'dart:io';

class CommentRemoteDataProvider implements CommentRepository {
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
  Future<Response<String>> deleteComment(String id) async {
    final url = Uri.parse('$apiUrl/comment/$id');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.deleteUrl(url);
      request.headers.contentType = ContentType.json;
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return Response.success("Delete Comment Success");
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to Delete Comment';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<Comment>> updateComment(Comment comment) async {
    final url = Uri.parse('$apiUrl/comment/${comment.id}');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.putUrl(url);
      request.headers.contentType = ContentType.json;
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });
      request.write(jsonEncode({
        "opportunityId": comment.opportunityId,
        "comment": comment.comment,
      }));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final updatedComment = Comment.fromJson(responseData);
        return Response.success(updatedComment);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to Update Comment';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<List<Comment>>> getOpportunityComments(String id) async {
    final url = Uri.parse('$apiUrl/comment/$id');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(url);
      request.headers.contentType = ContentType.json;
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final comments = responseData
            .map((json) => Comment.fromJson(json))
            .cast<Comment>()
            .toList();
        return Response.success(comments);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to fetch comments';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<Comment>> createComment(
    String opportunityId,
    String comment,
  ) async {
    final url = Uri.parse('$apiUrl/comment');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.postUrl(url);
      request.headers.contentType = ContentType.json;
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });
      request.write(jsonEncode({
        "opportunityId": opportunityId,
        "comment": comment,
      }));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final createdComment = Comment.fromJson(responseData);
        return Response.success(createdComment);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to Create Comment';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }
}
