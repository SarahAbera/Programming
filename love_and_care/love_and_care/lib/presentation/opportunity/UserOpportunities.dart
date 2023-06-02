import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:love_and_care/application/application.dart';
import 'package:love_and_care/domain/domain.dart';
import 'package:love_and_care/presentation/presentation.dart';

class UserEventsScreen extends StatefulWidget {
  final String role;
  const UserEventsScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<UserEventsScreen> createState() => _UserEventsScreenState();
}

class _UserEventsScreenState extends State<UserEventsScreen> {
  late OpportunityBloc _opportunityBloc;
  late UserBloc _userBloc;
  User? _user;

  @override
  void initState() {
    super.initState();
    _opportunityBloc = BlocProvider.of<OpportunityBloc>(context);
    if (widget.role == "Volunteer") {
      _opportunityBloc.add(FetchParticipated());
    } else {
      _opportunityBloc.add(FetchMyEvenets());
    }

    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(GetLoggedUserEvent());

    // Redirect to splash screen if there is no logged-in user
    _userBloc.stream.listen((state) {
      if (state is UserSuccess) {
        _user = state.user;
      } else if (state is UserFailure) {
        // No logged-in user, redirect to splash screen
        GoRouter.of(context).push('/splash');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current route

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        appBarText: 'Volunteer Opportunities',
      ),
      body: BlocConsumer<OpportunityBloc, OpportunityState>(
        listener: (context, state) {
          if (state is DeleteOpportunitySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Opportunity Delete successfully")),
            );
          } else if (state is OpportunityFailure) {
            // Show an error message.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          if (state is OpportunityLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OpportunitySuccess) {
            final opportunities = state.globalState.opportunities;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.role == "Volunteer"
                        ? 'Participated Events'
                        : "My Events",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                      visible: opportunities.isEmpty,
                      replacement: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: opportunities.length,
                        itemBuilder: (context, index) {
                          final opportunity = opportunities[index];
                          return OpportunityCard(
                            opportunity: opportunity,
                            currentUserUsername: _user!.username,
                          );
                        },
                      ),
                      child: Center(
                          child: Column(
                        children: [
                          Text(
                            widget.role == "Volunteer"
                                ? 'There are no opportunities you have participated in.'
                                : "You have not create any event yet.",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                GoRouter.of(context).push("/");
                              },
                              child: const Text("Go back home"))
                        ],
                      )))
                ],
              ),
            );
          } else if (state is OpportunityFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to fetch opportunities'),
                  ElevatedButton(
                    onPressed: () {
                      _opportunityBloc.add(FetchOpportunities());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserSuccess && _user?.role == 'Volunteer Seeker') {
            return FloatingActionButton.extended(
              backgroundColor: const Color(0xFFB73E3E),
              onPressed: () {
                // Perform action for adding an event
                GoRouter.of(context).push("/create-opportunity");
              },
              icon: const Icon(
                Icons.add,
              ),
              label: const Text('Event'),
              tooltip: 'Add Event',
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
