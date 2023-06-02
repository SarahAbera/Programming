import '../../domain/comment/comment_model.dart';
import '../response.dart';

abstract class CommentRepository {
  Future<Response<List<Comment>>> getOpportunityComments(String id);
  Future<Response<Comment>> createComment(String opportunityId, String comment);
  Future<Response<Comment>> updateComment(Comment comment);
  Future<Response<String>> deleteComment(String id);
}
