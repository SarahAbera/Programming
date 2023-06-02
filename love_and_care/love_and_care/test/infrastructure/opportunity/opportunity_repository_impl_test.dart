import 'package:flutter_test/flutter_test.dart';
import 'package:love_and_care/core/network/network_info.dart';
import 'package:love_and_care/domain/opportunity/opportunity_%20model.dart';
import 'package:love_and_care/infrastructure/opportunity/opportunity_local_data_provider.dart';
import 'package:love_and_care/infrastructure/opportunity/opportunity_remote_data_provider.dart';
import 'package:love_and_care/infrastructure/opportunity/opportunity_repository_impl.dart';
import 'package:love_and_care/infrastructure/response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opportunity_repository_impl_test.mocks.dart';

@GenerateMocks([
  OpportunityRemoteDataProvider,
  OpportunityLocalDataProvider,
  NetworkInfo,
])
void main() {
  late OpportunitRepositoryImpl repository;
  late MockOpportunityRemoteDataProvider mockRemoteDataProvider;
  late MockOpportunityLocalDataProvider mockLocalDataProvider;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataProvider = MockOpportunityRemoteDataProvider();
    mockLocalDataProvider = MockOpportunityLocalDataProvider();
    mockNetworkInfo = MockNetworkInfo();
    repository = OpportunitRepositoryImpl(
      remoteDataProvider: mockRemoteDataProvider,
      localDataProvider: mockLocalDataProvider,
      networkInfo: mockNetworkInfo,
    );
  });

  final title = 'title';
  final description = 'description';
  final date = DateTime.now();
  final location = 'location';
  final opportunityId = '1';

  final opportunity = Opportunity(
    opportunityId: opportunityId,
    volunteerSeeker: "volunteerSeeker",
    title: title,
    description: description,
    date: date,
    location: location,
    totalLikes: 1,
    totalParticipants: 1,
    likes: [],
    participants: [],
  );

  final response = Response<Opportunity>.success(opportunity);

  group('Opportunity Repository', () {
    group("Create Opportunity", () {
      test('Create Opportunity should return success response', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.CreateOpportunity(
          title,
          description,
          date.toIso8601String(),
          location,
        )).thenAnswer((_) async => response);
        when(mockLocalDataProvider.syncCreateOpportunity(opportunity))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.createOpportunity(
          title,
          description,
          date.toIso8601String(),
          location,
        );

        // Assert
        expect(result.data, response.data);
        verify(mockRemoteDataProvider.CreateOpportunity(
          title,
          description,
          date.toIso8601String(),
          location,
        ));
        verify(mockLocalDataProvider.syncCreateOpportunity(opportunity));
      });

      test('Create Opportunity should return error response', () async {
        // Arrange
        final errorMessage = 'Failed to create opportunity';
        final errorResponse = Response<Opportunity>.error(errorMessage);

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.CreateOpportunity(
          title,
          description,
          date.toIso8601String(),
          location,
        )).thenAnswer((_) async => errorResponse);

        // Act
        final result = await repository.createOpportunity(
          title,
          description,
          date.toIso8601String(),
          location,
        );

        // Assert
        expect(result.error, errorMessage);
        verify(mockRemoteDataProvider.CreateOpportunity(
          title,
          description,
          date.toIso8601String(),
          location,
        ));
        verifyZeroInteractions(mockLocalDataProvider);
      });
    });

    group("Update Opportunity", () {
      test('Update Opportunity should return success response', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.UpdateOpportunity(opportunity))
            .thenAnswer((_) async => response);
        when(mockLocalDataProvider.UpdateOpportunity(opportunity))
            .thenAnswer((_) async => response);

        // Act
        final result = await repository.updateOpportunity(opportunity);

        // Assert
        expect(result.data, response.data);
        verify(mockRemoteDataProvider.UpdateOpportunity(opportunity));
        verify(mockLocalDataProvider.UpdateOpportunity(opportunity));
      });

      test('Update Opportunity should return error response', () async {
        // Arrange
        final errorMessage = 'Failed to update the opportunity';
        final errorResponse = Response<Opportunity>.error(errorMessage);

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.UpdateOpportunity(opportunity))
            .thenAnswer((_) async => errorResponse);

        // Act
        final result = await repository.updateOpportunity(opportunity);

        // Assert
        expect(result.error, errorMessage);
        verify(mockRemoteDataProvider.UpdateOpportunity(opportunity));
        verifyZeroInteractions(mockLocalDataProvider);
      });
    });

    group("Delete Opportunity", () {
      final deleteResponse = Response<String>.success("Delete success");

      test('Delete Opportunity should return success response', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.DeleteOpportunity(opportunityId))
            .thenAnswer((_) async => deleteResponse);
        when(mockLocalDataProvider.DeleteOpportunity(opportunityId))
            .thenAnswer((_) async => deleteResponse);

        // Act
        final result = await repository.deleteOpportunity(opportunityId);

        // Assert
        expect(result.data, deleteResponse.data);
        verify(mockRemoteDataProvider.DeleteOpportunity(opportunityId));
        verify(mockLocalDataProvider.DeleteOpportunity(opportunityId));
      });

      test('Delete Opportunity should return error response', () async {
        // Arrange
        final errorMessage = 'Failed to delete opportunity';
        final errorResponse = Response<String>.error(errorMessage);

        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataProvider.DeleteOpportunity(opportunityId))
            .thenAnswer((_) async => errorResponse);

        // Act
        final result = await repository.deleteOpportunity(opportunityId);

        // Assert
        expect(result.error, errorMessage);
        verify(mockRemoteDataProvider.DeleteOpportunity(opportunityId));
        verifyZeroInteractions(mockLocalDataProvider);
      });
    });
  });
}
