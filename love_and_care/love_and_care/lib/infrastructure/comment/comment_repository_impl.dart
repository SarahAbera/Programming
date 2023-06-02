import 'package:love_and_care/domain/comment/comment_model.dart';

import '../response.dart';
import 'comment_local_data_provider.dart';
import 'comment_remote_data_provider.dart';
import 'comment_repository.dart';

import 'package:love_and_care/core/network/network_info.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataProvider remoteDataProvider;
  final CommentLocalDataProvider localDataProvider;
  final NetworkInfo networkInfo;

  CommentRepositoryImpl({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  @override
  Future<Response<List<Comment>>> getOpportunityComments(String id) async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse =
            await remoteDataProvider.getOpportunityComments(id);

        if (remoteResponse.data != null) {
          // await localDataProvider.syncGetOpportunityComments(
          //     id, remoteResponse.data!);
          return remoteResponse;
        } else {
          return Response.error('Failed to fetch comments');
        }
      } else {
        final localResponse =
            await localDataProvider.getOpportunityComments(id);

        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error('No comments found in the local data');
        }
      }
    } catch (e) {
      return Response.error('An error occurred while fetching comments');
    }
  }

  @override
  Future<Response<Comment>> createComment(
      String opportunityId, String comment) async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse =
            await remoteDataProvider.createComment(opportunityId, comment);
        return remoteResponse;
        //   if (remoteResponse.data != null) {
        //     // await localDataProvider.syncCreateComment(remoteResponse.data!);
        //     return remoteResponse;
        //   } else {
        //     return Response.error('Failed to create comment');
        //   }
        // } else {
        //   final localResponse =
        //       await localDataProvider.createComment(opportunityId, comment);

        //   if (localResponse.data != null) {
        //     return localResponse;
        // }
        //  else {
        //   return Response.error('Failed to create comment locally');
        // }
      } else {
        return Response.error('Failed to create comment locally');
      }
    } catch (e) {
      return Response.error(e.toString());

      return Response.error('An error occurred while creating comment');
    }
  }

  @override
  Future<Response<Comment>> updateComment(Comment comment) async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse = await remoteDataProvider.updateComment(comment);

        if (remoteResponse.data != null) {
          await localDataProvider.updateComment(remoteResponse.data!);
          return remoteResponse;
        } else {
          return Response.error('Failed to update comment');
        }
      } else {
        final localResponse = await localDataProvider.updateComment(comment);

        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error('Failed to update comment locally');
        }
      }
    } catch (e) {
      return Response.error('An error occurred while updating comment');
    }
  }

  @override
  Future<Response<String>> deleteComment(String id) async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse = await remoteDataProvider.deleteComment(id);

        if (remoteResponse.data != null) {
          await localDataProvider.deleteComment(id);
          return remoteResponse;
        } else {
          return Response.error('Failed to delete comment');
        }
      } else {
        final localResponse = await localDataProvider.deleteComment(id);
        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error('Failed to delete comment locally');
        }
      }
    } catch (e) {
      return Response.error('An error occurred while deleting comment');
    }
  }
}
