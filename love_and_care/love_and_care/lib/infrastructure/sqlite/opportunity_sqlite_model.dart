import 'package:sqflite/sqflite.dart';

import '../../domain/opportunity/opportunity_ model.dart';

class OpportunitySQLiteModel {
  static const tableName = 'opportunities';

  static const columnId = '_id';
  static const columnVolunteerSeeker = 'volunteer_seeker';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnDate = 'date';
  static const columnLocation = 'location';
  static const columnTotalLikes = 'total_likes';
  static const columnTotalParticipants = 'total_participants';
  static const columnLikes = 'likes';
  static const columnParticipants = 'participants';

  final String opportunityId;
  final String volunteerSeeker;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  int totalLikes;
  int totalParticipants;
  final List<String> likes;
  final List<String> participants;

  OpportunitySQLiteModel({
    required this.opportunityId,
    required this.volunteerSeeker,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.totalLikes,
    required this.totalParticipants,
    required this.likes,
    required this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      columnId: opportunityId,
      columnVolunteerSeeker: volunteerSeeker,
      columnTitle: title,
      columnDescription: description,
      columnDate: date.toIso8601String(),
      columnLocation: location,
      columnTotalLikes: totalLikes,
      columnTotalParticipants: totalParticipants,
      columnLikes: likes.join(','),
      columnParticipants: participants.join(','),
    };
  }

  factory OpportunitySQLiteModel.fromMap(Map<String, dynamic> map) {
    return OpportunitySQLiteModel(
      opportunityId: map[columnId] as String,
      volunteerSeeker: map[columnVolunteerSeeker] as String,
      title: map[columnTitle] as String,
      description: map[columnDescription] as String,
      date: DateTime.parse(map[columnDate] as String),
      location: map[columnLocation] as String,
      totalLikes: map[columnTotalLikes] as int,
      totalParticipants: map[columnTotalParticipants] as int,
      likes: (map[columnLikes] as String).split(','),
      participants: (map[columnParticipants] as String).split(','),
    );
  }

  Opportunity toOpportunity() {
    return Opportunity(
      opportunityId: opportunityId,
      volunteerSeeker: volunteerSeeker,
      title: title,
      description: description,
      date: date,
      location: location,
      totalLikes: totalLikes,
      totalParticipants: totalParticipants,
      likes: likes,
      participants: participants,
    );
  }

  factory OpportunitySQLiteModel.fromOpportunity(Opportunity opportunity) {
    return OpportunitySQLiteModel(
      opportunityId: opportunity.opportunityId,
      volunteerSeeker: opportunity.volunteerSeeker,
      title: opportunity.title,
      description: opportunity.description,
      date: opportunity.date,
      location: opportunity.location,
      totalLikes: opportunity.totalLikes,
      totalParticipants: opportunity.totalParticipants,
      likes: opportunity.likes,
      participants: opportunity.participants,
    );
  }

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $columnId TEXT PRIMARY KEY,
        $columnVolunteerSeeker TEXT,
        $columnTitle TEXT,
        $columnDescription TEXT,
        $columnDate TEXT,
        $columnLocation TEXT,
        $columnTotalLikes INTEGER,
        $columnTotalParticipants INTEGER,
        $columnLikes TEXT,
        $columnParticipants TEXT
      )
    ''');
  }
}
