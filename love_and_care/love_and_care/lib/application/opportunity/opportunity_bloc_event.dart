import '../../domain/opportunity/opportunity_ model.dart';

abstract class OpportunityEvent {}

class FetchOpportunities extends OpportunityEvent {}

class FetchParticipated extends OpportunityEvent {}

class FetchMyEvenets extends OpportunityEvent {}

class CreateOpportunity extends OpportunityEvent {
  final String title;
  final String description;
  final String date;
  final String location;

  CreateOpportunity(
      {required this.title,
      required this.description,
      required this.date,
      required this.location});
}

class UpdateOpportunity extends OpportunityEvent {
  final Opportunity opportunity;

  UpdateOpportunity({required this.opportunity});
}

class DeleteOpportunity extends OpportunityEvent {
  final String id;

  DeleteOpportunity({required this.id});
}

class GetOpportunity extends OpportunityEvent {
  final String id;

  GetOpportunity({required this.id});
}

class LikeOpportunity extends OpportunityEvent {
  final String id;
  final String path;

  LikeOpportunity({required this.id, required this.path});
}

class ParticipateOpportunity extends OpportunityEvent {
  final String id;
  final String path;

  ParticipateOpportunity({required this.id, required this.path});
}
