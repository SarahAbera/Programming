import '../../domain/opportunity/opportunity_ model.dart';
import '../response.dart';

abstract class OpportunityRepository {
  Future<Response<List<Opportunity>>> getAllOpportunities();
  Future<Response<List<Opportunity>>> getMyEvents();
  Future<Response<List<Opportunity>>> getParticipated();
  Future<Response<Opportunity?>> getOpportunity(String id);

  Future<Response<Opportunity>> createOpportunity(
      String title, String description, String date, String location);
  Future<Response<Opportunity>> updateOpportunity(Opportunity opportunity);
  Future<Response<String>> deleteOpportunity(String id);

  Future<Response<Opportunity>> participateOpportunity(String id);
  Future<Response<Opportunity>> likeOpportunity(String id);
}
