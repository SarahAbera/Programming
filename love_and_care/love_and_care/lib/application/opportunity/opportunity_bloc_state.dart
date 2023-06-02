import '../../domain/opportunity/opportunity_ model.dart';
import 'package:equatable/equatable.dart';

class OpportunityGlobalState {
  List<Opportunity> opportunities;

  OpportunityGlobalState({required this.opportunities});
}

abstract class OpportunityState extends Equatable {
  const OpportunityState();

  @override
  List<Object> get props => [];
}

class OpportunityInitial extends OpportunityState {}

class OpportunityLoading extends OpportunityState {}

class OpportunityLikeLoading extends OpportunityState {
  final String id;

  const OpportunityLikeLoading(this.id);
}

class OpportunityParticipateLoading extends OpportunityState {
  final String id;

  const OpportunityParticipateLoading(this.id);
}

class OpportunitySuccess extends OpportunityState {
  final OpportunityGlobalState globalState;

  const OpportunitySuccess(this.globalState);

  @override
  List<Object> get props => [globalState];
}

class OpportunityFailure extends OpportunityState {
  final String errorMessage;

  const OpportunityFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class DeleteOpportunitySuccess extends OpportunityState {}

class CreateOpportunitySuccess extends OpportunityState {}

class UpdateOpportunitySuccess extends OpportunityState {}

class GetOpportunitySuccess extends OpportunityState {
  final Opportunity opportunity;

  const GetOpportunitySuccess(this.opportunity);
}
