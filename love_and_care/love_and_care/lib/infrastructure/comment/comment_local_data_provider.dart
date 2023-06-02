import 'dart:convert';

import 'package:love_and_care/domain/comment/comment_model.dart';
import 'package:love_and_care/infrastructure/comment/comment_repository.dart';
import 'package:love_and_care/infrastructure/response.dart';

import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/auth/user_model.dart';
import '../sqlite/comment_sqlite_model.dart';
import '../sqlite/database_helper.dart';

class CommentLocalDataProvider implements CommentRepository {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final String loggedInUserKey = 'loggedInUser';

  Future<void> syncGetComments(List<Comment> comments, String id) async {
    final db = await dbHelper.database;

    final existingComments = await getOpportunityComments(id);

    final newComments = comments.where((comment) => !existingComments.data!
        .any((existingComment) => existingComment.id == comment.id));

    for (final comment in newComments) {
      final commentModel = CommentSQLiteModel.fromComment(comment);
      await db.insert(CommentSQLiteModel.tableName, commentModel.toMap());
    }
  }

  Future<void> syncCreateComment(Comment comment) async {
    final db = await dbHelper.database;
    final commentModel = CommentSQLiteModel.fromComment(comment);
    await db.insert(CommentSQLiteModel.tableName, commentModel.toMap());
  }

  @override
  Future<Response<Comment>> createComment(
      String opportunityId, String comment) async {
    final database = await dbHelper.database;

    try {
      final commentModel = CommentSQLiteModel(
        id: generateUniqueId(),
        opportunityId: opportunityId,
        username: await getUsername(),
        comment: comment,
        date: DateTime.now(),
      );

      await database.insert(
        CommentSQLiteModel.tableName,
        commentModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return Response.success(commentModel.toComment());
    } catch (e) {
      return Response.error('Failed to create comment');
    }
  }

  @override
  Future<Response<String>> deleteComment(String id) async {
    try {
      final database = await dbHelper.database;

      final rowsAffected = await database.delete(
        CommentSQLiteModel.tableName,
        where: '${CommentSQLiteModel.columnId} = ?',
        whereArgs: [id],
      );

      if (rowsAffected > 0) {
        return Response.success('Comment deleted successfully');
      } else {
        return Response.error('Failed to delete comment');
      }
    } catch (e) {
      return Response.error('An error occurred while deleting comment');
    }
  }

  @override
  Future<Response<Comment>> updateComment(Comment comment) async {
    try {
      final database = await dbHelper.database;

      final commentModel = CommentSQLiteModel.fromComment(comment);

      final rowsAffected = await database.update(
        CommentSQLiteModel.tableName,
        commentModel.toMap(),
        where: '${CommentSQLiteModel.columnId} = ?',
        whereArgs: [comment.id],
      );

      if (rowsAffected > 0) {
        return Response.success(comment);
      } else {
        return Response.error('Failed to update comment');
      }
    } catch (e) {
      return Response.error('An error occurred while updating comment');
    }
  }

  @override
  Future<Response<List<Comment>>> getOpportunityComments(String id) async {
    try {
      final database = await dbHelper.database;

      final List<Map<String, dynamic>> result = await database.query(
        CommentSQLiteModel.tableName,
        where: '${CommentSQLiteModel.columnOpportunityId} = ?',
        whereArgs: [id],
      );

      final comments = result
          .map((map) => CommentSQLiteModel.fromMap(map).toComment())
          .toList();

      return Response.success(comments);
    } catch (e) {
      return Response.error('An error occurred while fetching comments');
    }
  }

  String generateUniqueId() {
    final uuid = Uuid();
    return uuid.v4();
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedInUserJson = prefs.getString(loggedInUserKey);
    final loggedInUser = User.fromJson(jsonDecode(loggedInUserJson!));
    return loggedInUser.username;
  }
}
