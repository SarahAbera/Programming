import 'package:love_and_care/domain/opportunity/opportunity_%20model.dart';
import '../../core/network/network_info.dart';
import '../response.dart';
import 'opportunity_local_data_provider.dart';
import 'opportunity_remote_data_provider.dart';
import 'opportunity_repository.dart';

class OpportunitRepositoryImpl implements OpportunityRepository {
  final OpportunityRemoteDataProvider remoteDataProvider;
  final OpportunityLocalDataProvider localDataProvider;
  final NetworkInfo networkInfo;

  OpportunitRepositoryImpl({
    required this.remoteDataProvider,
    required this.localDataProvider,
    required this.networkInfo,
  });

  @override
  Future<Response<Opportunity>> createOpportunity(
      String title, String description, String date, String location) async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse = await remoteDataProvider.createOpportunity(
          title,
          description,
          date,
          location,
        );

        if (remoteResponse.data != null) {
          await localDataProvider.syncCreateOpportunity(remoteResponse.data!);
          return remoteResponse;
        } else {
          return Response.error('Failed to create opportunity');
        }
      } else {
        final localResponse = await localDataProvider.createOpportunity(
          title,
          description,
          date,
          location,
        );
        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error('Failed to create opportunity locally');
        }
      }
    } catch (e) {
      return Response.error('An error occurred while creating opportunity');
    }
  }

  @override
  Future<Response<Opportunity>> updateOpportunity(
      Opportunity opportunity) async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse =
            await remoteDataProvider.updateOpportunity(opportunity);

        if (remoteResponse.data != null) {
          await localDataProvider.updateOpportunity(remoteResponse.data!);
          return remoteResponse;
        } else {
          return Response.error('Failed to update the opportunity');
        }
      } else {
        final localResponse =
            await localDataProvider.updateOpportunity(opportunity);

        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error(
              'No internet connection. Unable to update the opportunity');
        }
      }
    } catch (e) {
      return Response.error('An error occurred while updating the opportunity');
    }
  }

  @override
  Future<Response<String>> deleteOpportunity(String id) async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse = await remoteDataProvider.deleteOpportunity(id);

        if (remoteResponse.data != null) {
          await localDataProvider.deleteOpportunity(id);
          return remoteResponse;
        } else {
          return Response.error('Failed to delete opportunity');
        }
      } else {
        final localResponse = await localDataProvider.deleteOpportunity(id);

        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error('Failed to delete opportunity locally');
        }
      }
    } catch (e) {
      return Response.error('An error occurred while deleting opportunity');
    }
  }

  @override
  Future<Response<List<Opportunity>>> getAllOpportunities() async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        var remoteResponse = await remoteDataProvider.getAllOpportunities();

        if (remoteResponse.data != null) {
          await localDataProvider.syncGetOpportunities(remoteResponse.data!);
          return remoteResponse;
        } else {
          return Response.error(
              'Failed to fetch opportunities from the remote server');
        }
      } else {
        final localResponse = await localDataProvider.getAllOpportunities();
        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error('No opportunities found in the local data');
        }
      }
    } catch (e) {
      return Response.error('An error occurred while fetching opportunities');
    }
  }

  @override
  Future<Response<List<Opportunity>>> getMyEvents() async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse = await remoteDataProvider.getMyEvents();

        if (remoteResponse.data != null) {
          await localDataProvider.syncGetOpportunities(remoteResponse.data!);
          return remoteResponse;
        } else {
          return Response.error(
              'Failed to fetch my events from the remote server');
        }
      } else {
        final localResponse = await localDataProvider.getMyEvents();

        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error('No my events found in the local data');
        }
      }
    } catch (e) {
      return Response.error('An error occurred while fetching my events');
    }
  }

  @override
  Future<Response<Opportunity?>> getOpportunity(String id) async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse = await remoteDataProvider.getOpportunity(id);

        if (remoteResponse.data != null) {
          return remoteResponse;
        } else {
          return Response.error(
              'Failed to fetch the opportunity from the remote server');
        }
      } else {
        final localResponse = await localDataProvider.getOpportunity(id);

        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error('No opportunity found in the local data');
        }
      }
    } catch (e) {
      return Response.error('An error occurred while fetching the opportunity');
    }
  }

  @override
  Future<Response<List<Opportunity>>> getParticipated() async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse = await remoteDataProvider.getParticipated();

        if (remoteResponse.data != null) {
          return remoteResponse;
        } else {
          return Response.error(
              'Failed to fetch participated opportunities from the remote server');
        }
      } else {
        final localResponse = await localDataProvider.getParticipated();

        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error(
              'No participated opportunities found in the local data');
        }
      }
    } catch (e) {
      return Response.error(
          'An error occurred while fetching participated opportunities');
    }
  }

  @override
  Future<Response<Opportunity>> likeOpportunity(String id) async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse = await remoteDataProvider.likeOpportunity(id);

        if (remoteResponse.data != null) {
          await localDataProvider.likeOpportunity(id);
          return remoteResponse;
        } else {
          return Response.error('Failed to like the opportunity');
        }
      } else {
        final localResponse = await localDataProvider.likeOpportunity(id);

        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error(
              'No internet connection. Unable to like the opportunity');
        }
      }
    } catch (e) {
      return Response.error('An error occurred while liking the opportunity');
    }
  }

  @override
  Future<Response<Opportunity>> participateOpportunity(String id) async {
    final isConnected = await networkInfo.isConnected;

    try {
      if (isConnected) {
        final remoteResponse =
            await remoteDataProvider.participateOpportunity(id);

        if (remoteResponse.data != null) {
          await localDataProvider.participateOpportunity(id);
          return remoteResponse;
        } else {
          return Response.error('Failed to participate in the opportunity');
        }
      } else {
        final localResponse =
            await localDataProvider.participateOpportunity(id);

        if (localResponse.data != null) {
          return localResponse;
        } else {
          return Response.error(
              'No internet connection. Unable to participate in the opportunity');
        }
      }
    } catch (e) {
      return Response.error(
          'An error occurred while participating in the opportunity');
    }
  }
}
