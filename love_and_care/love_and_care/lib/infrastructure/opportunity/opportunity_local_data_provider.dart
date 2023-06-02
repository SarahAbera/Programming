import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/auth/user_model.dart';
import '../../domain/opportunity/opportunity_ model.dart';
import '../response.dart';
import '../sqlite/database_helper.dart';
import '../sqlite/opportunity_sqlite_model.dart';
import 'opportunity_repository.dart';

class OpportunityLocalDataProvider implements OpportunityRepository {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final String loggedInUserKey = 'loggedInUser';

  @override
  Future<Response<List<Opportunity>>> getAllOpportunities() async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps =
          await db.query(OpportunitySQLiteModel.tableName);

      final opportunities = maps
          .map((map) => OpportunitySQLiteModel.fromMap(map).toOpportunity())
          .toList();

      return Response.success(opportunities);
    } catch (e) {
      return Response.error('Failed to fetch opportunities');
    }
  }

  @override
  Future<Response<String>> deleteOpportunity(String id) async {
    try {
      final db = await dbHelper.database;
      await db.delete(
        OpportunitySQLiteModel.tableName,
        where: '${OpportunitySQLiteModel.columnId} = ?',
        whereArgs: [id],
      );
      return Response.success('Opportunity deleted successfully');
    } catch (e) {
      return Response.error('Failed to delete the opportunity');
    }
  }

  Future<void> syncGetOpportunities(List<Opportunity> opportunities) async {
    final db = await dbHelper.database;
    final existingOpportunities = await getAllOpportunities();

    final newOpportunities = opportunities.where((opportunity) =>
        !existingOpportunities.data!.any((existingOpportunity) =>
            existingOpportunity.opportunityId == opportunity.opportunityId));

    for (final opportunity in newOpportunities) {
      final opportunityModel =
          OpportunitySQLiteModel.fromOpportunity(opportunity);
      await db.insert(
          OpportunitySQLiteModel.tableName, opportunityModel.toMap());
    }
  }

  Future<void> syncCreateOpportunity(Opportunity opportunity) async {
    final db = await dbHelper.database;
    final opportunityModel =
        OpportunitySQLiteModel.fromOpportunity(opportunity);
    await db.insert(OpportunitySQLiteModel.tableName, opportunityModel.toMap());
  }

  @override
  Future<Response<Opportunity>> createOpportunity(
      String title, String description, String date, String location) async {
    try {
      final db = await dbHelper.database;

      final opportunity = OpportunitySQLiteModel(
        volunteerSeeker: '',
        title: title,
        description: description,
        date: DateTime.parse(date),
        location: location,
        totalLikes: 0,
        totalParticipants: 0,
        likes: [],
        participants: [],
        opportunityId: '1',
      );

      await db.insert(OpportunitySQLiteModel.tableName, opportunity.toMap());
      return Response.success(opportunity.toOpportunity());
    } catch (e) {
      return Response.error('Failed to create the opportunity');
    }
  }

  @override
  Future<Response<Opportunity?>> getOpportunity(String id) async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        OpportunitySQLiteModel.tableName,
        where: '${OpportunitySQLiteModel.columnId} = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        final opportunity =
            OpportunitySQLiteModel.fromMap(maps.first).toOpportunity();
        return Response.success(opportunity);
      } else {
        return Response.success(null);
      }
    } catch (e) {
      return Response.error('Failed to get opportunity');
    }
  }

  @override
  Future<Response<Opportunity>> updateOpportunity(
      Opportunity opportunity) async {
    try {
      final db = await dbHelper.database;

      final updatedOpportunity =
          OpportunitySQLiteModel.fromOpportunity(opportunity);

      await db.update(
        OpportunitySQLiteModel.tableName,
        updatedOpportunity.toMap(),
        where: '${OpportunitySQLiteModel.columnId} = ?',
        whereArgs: [opportunity.opportunityId],
      );

      return Response.success(opportunity);
    } catch (e) {
      return Response.error('Failed to update the opportunity');
    }
  }

  @override
  Future<Response<List<Opportunity>>> getMyEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedInUserJson = prefs.getString(loggedInUserKey);

    if (loggedInUserJson != null) {
      final loggedInUser = User.fromJson(jsonDecode(loggedInUserJson));
      final db = await dbHelper.database;

      try {
        final List<Map<String, dynamic>> maps = await db.query(
          OpportunitySQLiteModel.tableName,
          where: '${OpportunitySQLiteModel.columnVolunteerSeeker} = ?',
          whereArgs: [loggedInUser.username],
        );

        final opportunities = maps
            .map((map) => OpportunitySQLiteModel.fromMap(map).toOpportunity())
            .toList();

        return Response.success(opportunities);
      } catch (e) {
        return Response.error('Failed to fetch events');
      }
    } else {
      return Response.error('User not logged in');
    }
  }

  @override
  Future<Response<List<Opportunity>>> getParticipated() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedInUserJson = prefs.getString(loggedInUserKey);

    if (loggedInUserJson != null) {
      final loggedInUser = User.fromJson(jsonDecode(loggedInUserJson));
      final db = await dbHelper.database;

      try {
        final List<Map<String, dynamic>> maps = await db.query(
          OpportunitySQLiteModel.tableName,
          where: '${OpportunitySQLiteModel.columnParticipants} LIKE ?',
          whereArgs: ['%${loggedInUser.username}%'],
        );

        final opportunities = maps
            .map((map) => OpportunitySQLiteModel.fromMap(map).toOpportunity())
            .toList();

        return Response.success(opportunities);
      } catch (e) {
        return Response.error('Failed to fetch participated events');
      }
    } else {
      return Response.error('User not logged in');
    }
  }

  @override
  Future<Response<Opportunity>> likeOpportunity(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final loggedInUserJson = prefs.getString(loggedInUserKey);

    if (loggedInUserJson != null) {
      final loggedInUser = User.fromJson(jsonDecode(loggedInUserJson));
      final db = await dbHelper.database;

      try {
        final List<Map<String, dynamic>> maps = await db.query(
          OpportunitySQLiteModel.tableName,
          where: '${OpportunitySQLiteModel.columnId} = ?',
          whereArgs: [id],
        );

        if (maps.isNotEmpty) {
          final opportunitySQLiteModel =
              OpportunitySQLiteModel.fromMap(maps.first);
          final opportunity = opportunitySQLiteModel.toOpportunity();

          if (opportunity.likes.contains(loggedInUser.username)) {

            opportunity.likes.remove(loggedInUser.username);
            opportunitySQLiteModel.likes.remove(loggedInUser.username);
            opportunitySQLiteModel.totalLikes -= 1;
          } else {
            opportunity.likes.add(loggedInUser.username);
            opportunitySQLiteModel.likes.add(loggedInUser.username);
            opportunitySQLiteModel.totalLikes += 1;
          }

          await db.update(
            OpportunitySQLiteModel.tableName,
            opportunitySQLiteModel.toMap(),
            where: '${OpportunitySQLiteModel.columnId} = ?',
            whereArgs: [id],
          );

          return Response.success(opportunity);
        } else {
          return Response.error('Invalid opportunity id');
        }
      } catch (e) {
        return Response.error('Failed to like/unlike the opportunity');
      }
    } else {
      return Response.error('User not logged in');
    }
  }

  @override
  Future<Response<Opportunity>> participateOpportunity(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final loggedInUserJson = prefs.getString(loggedInUserKey);

    if (loggedInUserJson != null) {
      final loggedInUser = User.fromJson(jsonDecode(loggedInUserJson));
      final db = await dbHelper.database;

      try {
        final List<Map<String, dynamic>> maps = await db.query(
          OpportunitySQLiteModel.tableName,
          where: '${OpportunitySQLiteModel.columnId} = ?',
          whereArgs: [id],
        );

        if (maps.isNotEmpty) {
          final opportunitySQLiteModel =
              OpportunitySQLiteModel.fromMap(maps.first);
          final opportunity = opportunitySQLiteModel.toOpportunity();

          if (opportunity.participants.contains(loggedInUser.username)) {
            opportunity.participants.remove(loggedInUser.username);
            opportunitySQLiteModel.participants.remove(loggedInUser.username);
            opportunitySQLiteModel.totalParticipants -= 1;
          } else {
            opportunity.participants.add(loggedInUser.username);
            opportunitySQLiteModel.participants.add(loggedInUser.username);
            opportunitySQLiteModel.totalParticipants += 1;
          }

          await db.update(
            OpportunitySQLiteModel.tableName,
            opportunitySQLiteModel.toMap(),
            where: '${OpportunitySQLiteModel.columnId} = ?',
            whereArgs: [id],
          );

          return Response.success(opportunity);
        } else {
          return Response.error('Invalid opportunity id');
        }
      } catch (e) {
        return Response.error('Failed to participate in the opportunity');
      }
    } else {
      return Response.error('User not logged in');
    }
  }
}
