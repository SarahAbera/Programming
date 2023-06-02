import 'package:flutter_test/flutter_test.dart';
import 'package:love_and_care/core/network/network_info.dart';
import 'package:love_and_care/domain/comment/comment_model.dart';
import 'package:love_and_care/infrastructure/comment/comment_local_data_provider.dart';
import 'package:love_and_care/infrastructure/comment/comment_remote_data_provider.dart';
import 'package:love_and_care/infrastructure/comment/comment_repository_impl.dart';
import 'package:love_and_care/infrastructure/response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'comment_repository_impl_test.mocks.dart';

@GenerateMocks([
  CommentRemoteDataProvider,
  CommentLocalDataProvider,
  NetworkInfo,
])
void main() {
  late CommentRepositoryImpl repository;
  late MockCommentRemoteDataProvider mockRemoteDataProvider;
  late MockCommentLocalDataProvider mockLocalDataProvider;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataProvider = MockCommentRemoteDataProvider();
    mockLocalDataProvider = MockCommentLocalDataProvider();
    mockNetworkInfo = MockNetworkInfo();
    repository = CommentRepositoryImpl(
      remoteDataProvider: mockRemoteDataProvider,
      localDataProvider: mockLocalDataProvider,
      networkInfo: mockNetworkInfo,
    );
  });

  final comment = 'comment';
  final opportunityId = '1';
  final date = DateTime.now();
  final username = 'username';
  final id = '1';

  final commentGiven = Comment(
    id: id,
    opportunityId: opportunityId,
    username: username,
    comment: comment,
    date: date,
  );
  final response = Response<Comment>.success(commentGiven);

  group('Comment Repository', () {
    // Test cases for CreateComment method
    group("Create comment", () {
      test('Create comment should return success response', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.CreateComment(opportunityId, comment))
            .thenAnswer((_) async => response);

        when(mockLocalDataProvider.CreateComment(opportunityId, comment))
            .thenAnswer((_) async => response);

        // Act
        final result = await repository.createComment(opportunityId, comment);

        // Assert
        expect(result.error, response.data);
        verify(mockRemoteDataProvider.CreateComment(opportunityId, comment));
      });

      test('Create comment should return error response', () async {
        // Arrange
        final errorMessage = 'Failed to create comment';
        final errorResponse = Response<Comment>.error(errorMessage);

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.CreateComment(opportunityId, comment))
            .thenAnswer((_) async => errorResponse);

        // Act
        final result = await repository.createComment(opportunityId, comment);

        // Assert
        expect(result.error, errorMessage);
        verify(mockRemoteDataProvider.CreateComment(opportunityId, comment));
      });
    });

    // Test cases for UpdateComment method
    group("Update comment", () {
      test('Update comment should return success response', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.UpdateComment(commentGiven))
            .thenAnswer((_) async => response);

        when(mockLocalDataProvider.UpdateComment(commentGiven))
            .thenAnswer((_) async => response);
        // Act
        final result = await repository.updateComment(commentGiven);

        // Assert
        expect(result.data, response.data);
        verify(mockRemoteDataProvider.UpdateComment(commentGiven));
      });

      test('Update comment should return error response', () async {
        // Arrange
        final errorMessage = 'Failed to update comment';
        final errorResponse = Response<Comment>.error(errorMessage);

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.UpdateComment(commentGiven))
            .thenAnswer((_) async => errorResponse);

        // Act
        final result = await repository.updateComment(commentGiven);

        // Assert
        expect(result.error, errorMessage);
        verify(mockRemoteDataProvider.UpdateComment(commentGiven));
      });
    });

    // Test cases for DeleteComment method
    group("Delete comment", () {
      final deleteResponse = Response.success("Delete success");

      test('Delete comment should return success response', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.DeleteComment(id))
            .thenAnswer((_) async => deleteResponse);

        when(mockLocalDataProvider.DeleteComment(id))
            .thenAnswer((_) async => deleteResponse);

        // Act
        final result = await repository.deleteComment(id);

        // Assert
        expect(result.data, deleteResponse.data);
        verify(mockRemoteDataProvider.DeleteComment(id));
      });

      test('Delete comment should return error response', () async {
        // Arrange
        final errorMessage = 'Failed to delete comment';
        final errorResponse = Response<String>.error(errorMessage);

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.DeleteComment(id))
            .thenAnswer((_) async => errorResponse);

        // Act
        final result = await repository.deleteComment(id);

        // Assert
        expect(result.error, errorMessage);
        verify(mockRemoteDataProvider.DeleteComment(id));
      });
    });

// Additional test cases for getOpportunityComments method
    group("Get opportunity comments", () {
      test('Get opportunity comments with network connection', () async {
        // Arrange
        final isConnected = true;
        final remoteResponse = Response<List<Comment>>.success([commentGiven]);

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => isConnected);
        when(mockRemoteDataProvider.getOpportunityComments(opportunityId))
            .thenAnswer((_) async => remoteResponse);

        // Act
        final result = await repository.getOpportunityComments(opportunityId);

        // Assert
        expect(result.data, remoteResponse.data);
        verify(mockRemoteDataProvider.getOpportunityComments(opportunityId));
      });

      test('Get opportunity comments without network connection', () async {
        // Arrange
        final isConnected = false;
        final localResponse = Response<List<Comment>>.success([commentGiven]);

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => isConnected);
        when(mockLocalDataProvider.getOpportunityComments(opportunityId))
            .thenAnswer((_) async => localResponse);

        // Act
        final result = await repository.getOpportunityComments(opportunityId);

        // Assert
        expect(result.data, localResponse.data);
        verify(mockLocalDataProvider.getOpportunityComments(opportunityId));
      });

      test(
          'Get opportunity comments with network connection and remote data is null',
          () async {
        // Arrange
        final isConnected = true;
        final remoteResponse = Response<List<Comment>>.success(null);

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => isConnected);
        when(mockRemoteDataProvider.getOpportunityComments(opportunityId))
            .thenAnswer((_) async => remoteResponse);

        // Act
        final result = await repository.getOpportunityComments(opportunityId);

        // Assert
        expect(result.error, 'Failed to fetch comments');
        verify(mockRemoteDataProvider.getOpportunityComments(opportunityId));
      });

      test(
          'Get opportunity comments without network connection and local data is null',
          () async {
        // Arrange
        final isConnected = false;
        final localResponse = Response<List<Comment>>.success(null);

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => isConnected);
        when(mockLocalDataProvider.getOpportunityComments(opportunityId))
            .thenAnswer((_) async => localResponse);

        // Act
        final result = await repository.getOpportunityComments(opportunityId);

        // Assert
        expect(result.error, 'No comments found in the local data');
        verify(mockLocalDataProvider.getOpportunityComments(opportunityId));
      });

      test(
          'Get opportunity comments with network connection throws an exception',
          () async {
        // Arrange
        final isConnected = true;

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => isConnected);
        when(mockRemoteDataProvider.getOpportunityComments(opportunityId))
            .thenThrow(Exception('An error occurred'));

        // Act
        final result = await repository.getOpportunityComments(opportunityId);

        // Assert

        expect(result.error, 'An error occurred while fetching comments');
        verify(mockRemoteDataProvider.getOpportunityComments(opportunityId));
      });

      test(
          'Get opportunity comments without network connection throws an exception',
          () async {
        // Arrange
        final isConnected = false;

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => isConnected);
        when(mockLocalDataProvider.getOpportunityComments(opportunityId))
            .thenThrow(Exception('An error occurred'));

        // Act
        final result = await repository.getOpportunityComments(opportunityId);

        // Assert
        expect(result.error, 'An error occurred while fetching comments');
        verify(mockLocalDataProvider.getOpportunityComments(opportunityId));
      });
    });
  });
}
