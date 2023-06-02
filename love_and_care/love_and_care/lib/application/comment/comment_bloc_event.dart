import '../../domain/comment/comment_model.dart';

abstract class CommentEvent {}

class CreateComment extends CommentEvent {
  final String opportunityId;
  final String comment;

  CreateComment({
    required this.comment,
    required this.opportunityId,
  });
}

class UpdateComment extends CommentEvent {
  final Comment comment;

  UpdateComment({required this.comment});
}

class DeleteComment extends CommentEvent {
  final String id;

  DeleteComment({required this.id});
}

class GetComments extends CommentEvent {
  final String id;

  GetComments({required this.id});
}
