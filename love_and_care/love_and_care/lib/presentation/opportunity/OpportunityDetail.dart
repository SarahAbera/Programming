import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:love_and_care/application/application.dart';
import 'package:love_and_care/domain/domain.dart';
import 'package:love_and_care/presentation/presentation.dart';

class OpportunityDetail extends StatefulWidget {
  final String id;

  const OpportunityDetail({required this.id, Key? key}) : super(key: key);

  @override
  _OpportunityDetailState createState() => _OpportunityDetailState();
}

class _OpportunityDetailState extends State<OpportunityDetail>
    with AutomaticKeepAliveClientMixin<OpportunityDetail> {
  late UserBloc _userBloc;
  late User _user;
  var isViewParticipants = false;
  var _opportunity;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final opportunityBloc = BlocProvider.of<OpportunityBloc>(context);
    opportunityBloc.add(GetOpportunity(id: widget.id));

    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(GetLoggedUserEvent());

    _userBloc.stream.listen((state) {
      if (!mounted) return; // Check if the state object is still mounted
      if (state is UserSuccess) {
        setState(() {
          _user = state.user;
        });
      } else if (state is UserFailure) {
        GoRouter.of(context).push('/splash');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<OpportunityBloc, OpportunityState>(
      listener: (context, state) {
        if (state is OpportunityFailure) {
          // Show the failure error message at the center of the screen
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Opportunity Error'),
                content: Text(state.errorMessage),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (state is GetOpportunitySuccess) {
          final newOpportunity = state.opportunity;

          // if (_opportunity != newOpportunity) {
          setState(() {
            _opportunity = newOpportunity;
          });
          // }
        } else if (state is DeleteOpportunitySuccess) {
          GoRouter.of(context).go("/");
        }
      },
      builder: (context, state) {
        if (state is OpportunityLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is OpportunityFailure) {
          return Scaffold(
            body: Center(
                child: Column(
              children: [
                Text(state.errorMessage),
                TextButton(
                  child: Text("Go Back Home"),
                  onPressed: () {
                    GoRouter.of(context).push("/");
                  },
                )
              ],
            )),
          );
        }
        if (_opportunity != null) {
          return Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              appBar: CustomAppBar(
                appBarText: 'Opportunity Detail',
              ),
              body: Center(
                child: Column(
                  children: [
                    OpportunityCard(
                        opportunity: _opportunity!,
                        currentUserUsername: _user.username),
                    if (_user.username ==
                        _opportunity!
                            .volunteerSeeker) // Show edit and delete buttons for the current user's opportunity
                      Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isViewParticipants = !isViewParticipants;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      isViewParticipants
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      isViewParticipants
                                          ? "Hide Participants"
                                          : "View Participants",
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // Handle edit button press
                                      GoRouter.of(context).push(
                                        "/update-opportunity/${_opportunity!.opportunityId}",
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text("Edit")
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirmation'),
                                            content: Text(
                                                'Are you sure you want to delete this event?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  // Handle cancel button press
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // Handle delete button press
                                                  final opportunityBloc =
                                                      BlocProvider.of<
                                                              OpportunityBloc>(
                                                          context);
                                                  opportunityBloc.add(
                                                      DeleteOpportunity(
                                                          id: _opportunity!
                                                              .opportunityId));
                                                  Navigator.of(context).pop();

                                                  // Call the delete method or trigger the delete operation
                                                },
                                                child: Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: !isViewParticipants
                          ? ChatScreen(
                              id: _opportunity!.opportunityId,
                              username: _user.username,
                            )
                          : ListView.builder(
                              itemCount: _opportunity!.participants.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16),
                                  child: Container(
                                    child:
                                        Text(_opportunity!.participants[index]),
                                  ),
                                );
                              },
                            ),
                    )
                  ],
                ),
              ));
        } else {
          return Scaffold(
            body: Center(
                child: Column(
              children: [
                Text("No opportunity found"),
                TextButton(
                  child: Text("Go Back Home"),
                  onPressed: () {
                    GoRouter.of(context).push("/");
                  },
                )
              ],
            )),
          );
        }
      },
    );
  }
}
