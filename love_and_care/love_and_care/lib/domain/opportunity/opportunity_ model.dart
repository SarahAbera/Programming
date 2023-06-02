import 'package:equatable/equatable.dart';

class Opportunity extends Equatable {
  final String opportunityId;
  final String volunteerSeeker;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final int totalLikes;
  final int totalParticipants;
  final List<String> likes;
  final List<String> participants;

 const  Opportunity({
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

  factory Opportunity.fromJson(Map<String, dynamic> json) {
    return Opportunity(
      opportunityId: json['_id'] as String,
      volunteerSeeker: json['username'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      totalLikes: json['totalLikes'] as int,
      totalParticipants: json['totalParticipants'] as int,
      likes: (json['likes'] as List<dynamic>)
          .map((like) => like as String)
          .toList(),
      participants: (json['participants'] as List<dynamic>)
          .map((participant) => participant as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': opportunityId,
      'userId': {'username': volunteerSeeker},
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'totalLikes': totalLikes,
      'totalParticipants': totalParticipants,
      'likes': likes,
      'participants': participants,
    };
  }

  @override
  List<Object?> get props => [
        opportunityId,
        volunteerSeeker,
        title,
        description,
        date,
        location,
        totalLikes,
        totalParticipants,
        likes,
        participants,
      ];
}
