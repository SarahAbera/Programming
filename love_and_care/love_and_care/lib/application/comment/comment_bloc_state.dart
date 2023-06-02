import 'package:equatable/equatable.dart';

import '../../domain/comment/comment_model.dart';

class CommentGlobalState {
  List<Comment> comments;

  CommentGlobalState({required this.comments});
}

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentSuccess extends CommentState {
  final CommentGlobalState globalState;

  const CommentSuccess(this.globalState);

  @override
  List<Object> get props => [globalState];
}

class CommentFailure extends CommentState {
  final String errorMessage;

  const CommentFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class DeleteCommentSuccess extends CommentState {}

class CreateCommentSuccess extends CommentState {}

class UpdateCommentSuccess extends CommentState {}

