import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String opportunityId;
  final String username;
  final String comment;
  final DateTime date;

  // Add other fields as needed

  const Comment(
      {required this.id,
      required this.opportunityId,
      required this.username,
      required this.comment,
      required this.date
      // Initialize other fields as needed
      });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] as String,
      opportunityId: json['opportunityId'] as String,
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'opportunityId': opportunityId,
      'comment': comment,
      'date': date.toIso8601String(),
      'username': username,
      // Add other fields as needed
    };
  }

  @override
  List<Object?> get props => [id, opportunityId, comment, date, username];
}
