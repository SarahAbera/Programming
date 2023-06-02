import 'package:flutter_bloc/flutter_bloc.dart';
import '../../infrastructure/comment/comment_repository.dart';
import 'comment_bloc_event.dart';
import 'comment_bloc_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository commentRepository;
  final CommentGlobalState globalState;

  CommentBloc(
    this.commentRepository,
    this.globalState,
  ) : super(CommentInitial()) {
    on<GetComments>(_onGetComments);
    on<CreateComment>(_onCreateComment);
    on<UpdateComment>(_onUpdateComment);
    on<DeleteComment>(_onDeleteComment);
  }

  void _onGetComments(GetComments event, Emitter<CommentState> emit) async {
    emit(CommentLoading());

    var response = await commentRepository.getOpportunityComments(event.id);
    if (response.data != null) {
      globalState.comments = response.data!;
      emit(CommentSuccess(globalState));
    } else {
      emit(CommentFailure(response.error!));
    }
  }

  void _onCreateComment(CreateComment event, Emitter<CommentState> emit) async {
    emit(CommentLoading());
    var response = await commentRepository.createComment(
        event.opportunityId, event.comment);
    if (response.data != null) {
      globalState.comments.add(response.data!);
      emit(CreateCommentSuccess());

      emit(CommentSuccess(globalState));
    } else {
      emit(CommentFailure(response.error!));
    }
  }

  void _onUpdateComment(UpdateComment event, Emitter<CommentState> emit) async {
    emit(CommentLoading());

    var response = await commentRepository.updateComment(event.comment);
    if (response.data != null) {
      // Find the index of the updated Comment
      final index = globalState.comments.indexWhere(
        (comment) => comment.id == event.comment.id,
      );
      if (index != -1) {
        globalState.comments[index] = event.comment;
      }
      emit(UpdateCommentSuccess());

      emit(CommentSuccess(globalState));
    } else {
      emit(CommentFailure(response.error!));
    }
  }

  void _onDeleteComment(DeleteComment event, Emitter<CommentState> emit) async {
    emit(CommentLoading());

    var response = await commentRepository.deleteComment(event.id);
    if (response.data != null) {
      globalState.comments.removeWhere(
        (comment) => comment.id == event.id,
      );
      emit(DeleteCommentSuccess());

      emit(CommentSuccess(globalState));
    } else {
      emit(CommentFailure(response.error!));
    }
  }
}
