import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/application.dart';
import '../../domain/domain.dart';
import '../presentation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  late OpportunityBloc _opportunityBloc;
  late UserBloc _userBloc;
  User? _user;
  List<Opportunity> _opportunities = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _opportunityBloc = BlocProvider.of<OpportunityBloc>(context);
    _opportunityBloc.add(FetchOpportunities());

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
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (ModalRoute.of(context)?.isCurrent == true) {
      // Navigated back to HomeScreen from another screen

      _opportunityBloc.add(FetchOpportunities());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current route
    super.build(context); // Ensure the state is kept alive

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        appBarText: 'Volunteer Opportunities',
      ),
      body: BlocConsumer<OpportunityBloc, OpportunityState>(
        listener: (context, state) {
          if (state is DeleteOpportunitySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Opportunity Delete successfully")),
            );
          } else if (state is OpportunityFailure) {
            // Show an error message.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          } else if (state is OpportunitySuccess) {
            final newOpportunities = state.globalState.opportunities;
            if (!listEquals(_opportunities, newOpportunities)) {
              setState(() {
                _opportunities = newOpportunities;
              });
            }
          }
        },
        builder: (context, state) {
          if (state is OpportunityLoading) {
            return const Center(
              child: CircularProgressIndicator(),
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

          return ListView.builder(
            itemCount: _opportunities.length,
            itemBuilder: (context, index) {
              final opportunity = _opportunities[index];
              return OpportunityCard(
                  opportunity: opportunity,
                  currentUserUsername: _user!.username);
            },
          );
        },
      ),
      floatingActionButton: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserSuccess && _user?.role == 'Volunteer Seeker') {
            return FloatingActionButton.extended(
              backgroundColor: Color(0xFFB73E3E),
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
