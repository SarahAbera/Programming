import 'package:sqflite/sqflite.dart';

import '../../domain/comment/comment_model.dart';

class CommentSQLiteModel {
  static const tableName = 'comments';

  static const columnId = '_id';
  static const columnOpportunityId = 'opportunity_id';
  static const columnUsername = 'username';
  static const columnComment = 'comment';
  static const columnDate = 'date';

  final String id;
  final String opportunityId;
  final String username;
  final String comment;
  final DateTime date;

  CommentSQLiteModel({
    required this.id,
    required this.opportunityId,
    required this.username,
    required this.comment,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnOpportunityId: opportunityId,
      columnUsername: username,
      columnComment: comment,
      columnDate: date.toIso8601String(),
    };
  }

  factory CommentSQLiteModel.fromMap(Map<String, dynamic> map) {
    return CommentSQLiteModel(
      id: map[columnId] as String,
      opportunityId: map[columnOpportunityId] as String,
      username: map[columnUsername] as String,
      comment: map[columnComment] as String,
      date: DateTime.parse(map[columnDate] as String),
    );
  }

  Comment toComment() {
    return Comment(
      id: id,
      opportunityId: opportunityId,
      username: username,
      comment: comment,
      date: date,
    );
  }

  factory CommentSQLiteModel.fromComment(Comment comment) {
    return CommentSQLiteModel(
      id: comment.id,
      opportunityId: comment.opportunityId,
      username: comment.username,
      comment: comment.comment,
      date: comment.date,
    );
  }

  static Future<void> createTable(Database db) async {
    await db.execute(
        '''
      CREATE TABLE $tableName (
        $columnId TEXT PRIMARY KEY,
        $columnOpportunityId TEXT,
        $columnUsername TEXT,
        $columnComment TEXT,
        $columnDate TEXT
      )
    ''');
  }
}
