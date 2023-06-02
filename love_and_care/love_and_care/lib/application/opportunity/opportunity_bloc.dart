import 'package:flutter_bloc/flutter_bloc.dart';
import '../../infrastructure/opportunity/opportunity_repository.dart';
import 'opportunity_bloc_event.dart';
import 'opportunity_bloc_state.dart';

class OpportunityBloc extends Bloc<OpportunityEvent, OpportunityState> {
  final OpportunityRepository opportunityRepository;
  final OpportunityGlobalState globalState;

  OpportunityBloc(
    this.opportunityRepository,
    this.globalState,
  ) : super(OpportunityInitial()) {
    on<FetchOpportunities>(_onFetchOpportunities);
    on<FetchMyEvenets>(_onFetchMyEvenets);
    on<FetchParticipated>(_onFetchParticipated);
    on<GetOpportunity>(_onGetOpportunity);

    on<CreateOpportunity>(_onCreateOpportunity);
    on<UpdateOpportunity>(_onUpdateOpportunity);
    on<LikeOpportunity>(_onLikeOpportunity);
    on<ParticipateOpportunity>(_onParticipateOpportunity);

    on<DeleteOpportunity>(_onDeleteOpportunity);
  }

  void _onFetchOpportunities(
      FetchOpportunities event, Emitter<OpportunityState> emit) async {
    emit(OpportunityLoading());

    var response = await opportunityRepository.getAllOpportunities();
    if (response.data != null) {
      globalState.opportunities = response.data!;
      emit(OpportunitySuccess(globalState));
    } else {
      emit(OpportunityFailure(response.error!));
    }
  }

  void _onFetchMyEvenets(
      FetchMyEvenets event, Emitter<OpportunityState> emit) async {
    emit(OpportunityLoading());

    var response = await opportunityRepository.getMyEvents();
    if (response.data != null) {
      globalState.opportunities = response.data!;
      emit(OpportunitySuccess(globalState));
    } else {
      emit(OpportunityFailure(response.error!));
    }
  }

  void _onFetchParticipated(
      FetchParticipated event, Emitter<OpportunityState> emit) async {
    emit(OpportunityLoading());
    var response = await opportunityRepository.getParticipated();
    if (response.data != null) {
      globalState.opportunities = response.data!;
      emit(OpportunitySuccess(globalState));
    } else {
      emit(OpportunityFailure(response.error!));
    }
  }

  void _onGetOpportunity(
      GetOpportunity event, Emitter<OpportunityState> emit) async {
    emit(OpportunityLoading());

    var response = await opportunityRepository.getOpportunity(event.id);
    if (response.data != null) {
      emit(GetOpportunitySuccess(response.data!));
    } else {
      emit(OpportunityFailure(response.error!));
    }
  }

  void _onCreateOpportunity(
      CreateOpportunity event, Emitter<OpportunityState> emit) async {
    emit(OpportunityLoading());

    var response = await opportunityRepository.createOpportunity(
        event.title, event.description, event.date, event.location);
    if (response.data != null) {
      globalState.opportunities.add(response.data!);
      emit(CreateOpportunitySuccess());

      emit(OpportunitySuccess(globalState));
    } else {
      emit(OpportunityFailure(response.error!));
    }
  }

  void _onUpdateOpportunity(
      UpdateOpportunity event, Emitter<OpportunityState> emit) async {
    emit(OpportunityLoading());

    var response =
        await opportunityRepository.updateOpportunity(event.opportunity);
    if (response.data != null) {
      // Find the index of the updated opportunity
      final index = globalState.opportunities.indexWhere(
        (opportunity) =>
            opportunity.opportunityId == event.opportunity.opportunityId,
      );
      if (index != -1) {
        globalState.opportunities[index] = event.opportunity;
      }
      emit(UpdateOpportunitySuccess());
    } else {
      emit(OpportunityFailure(response.error!));
    }
  }

  void _onLikeOpportunity(
      LikeOpportunity event, Emitter<OpportunityState> emit) async {
    emit(OpportunityLikeLoading(event.id));

    var response = await opportunityRepository.likeOpportunity(event.id);
    if (response.data != null) {
      if (event.path == "/" ||
          event.path == "Volunteer-Seeker" ||
          event.path == "Volunteer") {
        final index = globalState.opportunities.indexWhere(
          (opportunity) => opportunity.opportunityId == event.id,
        );
        if (index != -1) {
          globalState.opportunities[index] = response.data!;
          emit(OpportunitySuccess(globalState));
        }
      } else {
        emit(GetOpportunitySuccess(response.data!));
      }
      emit(UpdateOpportunitySuccess());
    } else {
      emit(OpportunityFailure(response.error!));
    }
  }

  void _onParticipateOpportunity(
      ParticipateOpportunity event, Emitter<OpportunityState> emit) async {
    emit(OpportunityParticipateLoading(event.id));

    var response = await opportunityRepository.participateOpportunity(event.id);
    if (response.data != null) {
      if (event.path == "/" ||
          event.path == "Volunteer-Seeker" ||
          event.path == "Volunteer") {
        final index = globalState.opportunities.indexWhere(
          (opportunity) => opportunity.opportunityId == event.id,
        );
        if (index != -1) {
          globalState.opportunities[index] = response.data!;
          emit(OpportunitySuccess(globalState));
        }
      } else {
        emit(GetOpportunitySuccess(response.data!));
      }
      emit(UpdateOpportunitySuccess());
    } else {
      emit(OpportunityFailure(response.error!));
    }
  }

  void _onDeleteOpportunity(
      DeleteOpportunity event, Emitter<OpportunityState> emit) async {
    emit(OpportunityLoading());

    var response = await opportunityRepository.deleteOpportunity(event.id);
    if (response.data != null) {
      globalState.opportunities.removeWhere(
        (opportunity) => opportunity.opportunityId == event.id,
      );
      emit(DeleteOpportunitySuccess());
      emit(OpportunitySuccess(globalState));
    } else {
      emit(OpportunityFailure(response.error!));
    }
  }
}
