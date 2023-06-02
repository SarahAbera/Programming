import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:love_and_care/application/application.dart';
import 'package:love_and_care/core/network/network_info.dart';
import 'package:love_and_care/domain/domain.dart';
import 'package:love_and_care/infrastructure/infrastucture.dart';
import 'package:love_and_care/presentation/presentation.dart';

class UpdateOpportunityScreen extends StatefulWidget {
  final String opportunityId;

  const UpdateOpportunityScreen({Key? key, required this.opportunityId})
      : super(key: key);

  @override
  _UpdateOpportunityScreenState createState() =>
      _UpdateOpportunityScreenState();
}

class _UpdateOpportunityScreenState extends State<UpdateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  late UserBloc _userBloc;
  User? _user;

  @override
  void initState() {
    super.initState();
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(GetLoggedUserEvent());

    // Redirect to splash screen if there is no logged-in user
    _userBloc.stream.listen((state) {
      if (state is UserSuccess) {
        _user = state.user;
        _loadOpportunityData();
      } else if (state is UserFailure) {
        // No logged-in user, redirect to splash screen
        GoRouter.of(context).push('/splash');
      }
    });
  }

  void _loadOpportunityData() {
    // Fetch the opportunity data using the opportunityId
    final opportunityBloc = BlocProvider.of<OpportunityBloc>(context);
    opportunityBloc.add(GetOpportunity(id: widget.opportunityId));

    opportunityBloc.stream.listen((state) {
      if (state is GetOpportunitySuccess) {
        final opportunity = state.opportunity;
        // Initialize the text fields with the opportunity's data
        _titleController.text = opportunity.title;
        _descriptionController.text = opportunity.description;
        _dateController.text = opportunity.date.toString();
        _locationController.text = opportunity.location;
      } else if (state is OpportunityFailure) {
        // Handle error retrieving opportunity data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage)),
        );
        GoRouter.of(context).push("/");
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OpportunityBloc>(
      create: (context) => OpportunityBloc(
          OpportunitRepositoryImpl(
            remoteDataProvider: OpportunityRemoteDataProvider(),
            localDataProvider: OpportunityLocalDataProvider(),
            networkInfo: NetworkInfoImpl(InternetConnectionChecker()),
          ),
          OpportunityGlobalState(opportunities: [])),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: CustomAppBar(
          appBarText: "Update Opportunity",
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<OpportunityBloc, OpportunityState>(
            listener: (context, state) {
              if (state is CreateOpportunitySuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Create Opportunity Success")),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  GoRouter.of(context).push("/");
                });
              } else if (state is UpdateOpportunitySuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Opportunity updated successfully")),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  GoRouter.of(context)
                      .push("/opportunity/${widget.opportunityId}");
                });
              } else if (state is OpportunityFailure) {
                // Show an error message.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
            },
            builder: (context, state) {
              if (state is OpportunityFailure) {
                return Center(
                    child: Column(
                  children: [
                    Text(state.errorMessage),
                    const SizedBox(
                      height: 8,
                    ),
                    TextButton(
                      child: const Text("Go back home"),
                      onPressed: () {
                        GoRouter.of(context).push("/");
                      },
                    ),
                  ],
                ));
              }
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 32,
                      ),
                      TitleTextField(controller: _titleController),
                      const SizedBox(height: 16),
                      DescriptionTextField(controller: _descriptionController),
                      const SizedBox(height: 16),
                      DateTextField(controller: _dateController),
                      const SizedBox(height: 16),
                      LocationTextField(controller: _locationController),
                      const SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final title = _titleController.text;
                            final description = _descriptionController.text;
                            final date = _dateController.text;
                            final location = _locationController.text;
                            final opportunityBloc =
                                BlocProvider.of<OpportunityBloc>(context);
                            if (widget.opportunityId == null) {
                              opportunityBloc.add(CreateOpportunity(
                                title: title,
                                description: description,
                                date: date,
                                location: location,
                              ));
                            } else {
                              Opportunity updateOpportunity = Opportunity(
                                opportunityId: widget.opportunityId,
                                volunteerSeeker: "",
                                title: title,
                                description: description,
                                date: DateTime.parse(date),
                                location: location,
                                totalLikes: 0,
                                totalParticipants: 0,
                                likes: [],
                                participants: [],
                              );
                              opportunityBloc.add(UpdateOpportunity(
                                opportunity: updateOpportunity,
                              ));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFB73E3E),
                          padding: const EdgeInsets.only(
                            left: 48,
                            right: 64,
                            top: 16,
                            bottom: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Update Opportunity',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
