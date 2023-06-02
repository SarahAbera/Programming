import 'dart:io';

import 'package:love_and_care/domain/opportunity/opportunity_%20model.dart';
import 'dart:convert';
import 'package:love_and_care/infrastructure/opportunity/opportunity_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../response.dart';

class OpportunityRemoteDataProvider implements OpportunityRepository {
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
  Future<Response<List<Opportunity>>> getAllOpportunities() async {
    final url = Uri.parse('$apiUrl/opportunity');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(url);
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final opportunities = (responseData as List<dynamic>)
            .map((json) => Opportunity.fromJson(json as Map<String, dynamic>))
            .toList();
        return Response.success(opportunities);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to fetch opportunities';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<String>> deleteOpportunity(String id) async {
    final url = Uri.parse('$apiUrl/opportunity/$id');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.deleteUrl(url);
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return Response.success("Delete Opportunity Success");
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to Delete opportunity';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<Opportunity?>> getOpportunity(String id) async {
    final url = Uri.parse('$apiUrl/opportunity/$id');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(url);
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final opportunity = Opportunity.fromJson(responseData);
        return Response.success(opportunity);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to Get opportunity';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<Opportunity>> updateOpportunity(
      Opportunity opportunity) async {
    final url = Uri.parse('$apiUrl/opportunity/${opportunity.opportunityId}');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.putUrl(url);
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final body = jsonEncode({
        "title": opportunity.title,
        "description": opportunity.description,
        "date": opportunity.date.toIso8601String(),
        "location": opportunity.location
      });
      request.write(body);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final opportunity = Opportunity.fromJson(responseData);
        return Response.success(opportunity);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to Update opportunity';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<Opportunity>> createOpportunity(
      String title, String description, String date, String location) async {
    final url = Uri.parse('$apiUrl/opportunity');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.postUrl(url);
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final body = jsonEncode({
        "title": title,
        "description": description,
        "date": date,
        "location": location
      });
      request.write(body);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final opportunity = Opportunity.fromJson(responseData);
        return Response.success(opportunity);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to Create opportunity';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<List<Opportunity>>> getMyEvents() async {
    final url = Uri.parse('$apiUrl/opportunity/user/events');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(url);
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final opportunities = (responseData as List<dynamic>)
            .map((json) => Opportunity.fromJson(json as Map<String, dynamic>))
            .toList();
        return Response.success(opportunities);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to fetch opportunities';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<List<Opportunity>>> getParticipated() async {
    final url = Uri.parse('$apiUrl/opportunity/user/participated');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(url);
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final opportunities = (responseData as List<dynamic>)
            .map((json) => Opportunity.fromJson(json as Map<String, dynamic>))
            .toList();
        return Response.success(opportunities);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to fetch opportunities';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<Opportunity>> likeOpportunity(String id) async {
    final url = Uri.parse('$apiUrl/opportunity/like/$id');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.putUrl(url);
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final opportunity = Opportunity.fromJson(responseData);
        return Response.success(opportunity);
      } else {
        final errorMessage = responseData['message'] ?? 'Failed to like/unlike';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }

  @override
  Future<Response<Opportunity>> participateOpportunity(String id) async {
    final url = Uri.parse('$apiUrl/opportunity/participate/$id');
    final headers = await getHeaders();

    try {
      final httpClient = HttpClient();
      final request = await httpClient.putUrl(url);
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final responseData = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        final opportunity = Opportunity.fromJson(responseData);
        return Response.success(opportunity);
      } else {
        final errorMessage =
            responseData['message'] ?? 'Failed to participate/unparticipate';
        return Response.error(errorMessage);
      }
    } catch (error) {
      return Response.error("Server Error");
    }
  }
}
