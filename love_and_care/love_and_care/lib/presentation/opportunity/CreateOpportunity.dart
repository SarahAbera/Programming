import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:love_and_care/application/application.dart';
import 'package:love_and_care/core/network/network_info.dart';
import 'package:love_and_care/domain/domain.dart';
import 'package:love_and_care/infrastructure/infrastucture.dart';
import 'package:love_and_care/presentation/presentation.dart';

class CreateOpportunityScreen extends StatefulWidget {
  const CreateOpportunityScreen({Key? key}) : super(key: key);

  @override
  _CreateOpportunityScreenState createState() =>
      _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState extends State<CreateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  late UserBloc _userBloc;
  User? _user;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

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
          appBarText: 'Create Opportunity',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<OpportunityBloc, OpportunityState>(
            listener: (context, state) {
              if (state is CreateOpportunitySuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Create Opportunity Success")),
                );
                Future.delayed(Duration(seconds: 1), () {
                  GoRouter.of(context).push("/");
                });
              } else if (state is OpportunityFailure) {
                // Show an error message.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 32,
                      ),
                      TitleTextField(controller: _titleController),
                      SizedBox(height: 16),
                      DescriptionTextField(controller: _descriptionController),
                      SizedBox(height: 16),
                      DateTextField(controller: _dateController),
                      SizedBox(height: 16),
                      LocationTextField(controller: _locationController),
                      SizedBox(height: 48),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final title = _titleController.text;
                            final description = _descriptionController.text;
                            final date = _dateController.text;
                            final location = _locationController.text;
                            final opportunityBloc =
                                BlocProvider.of<OpportunityBloc>(context);
                            opportunityBloc.add(CreateOpportunity(
                              title: title,
                              description: description,
                              date: date,
                              location: location,
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFB73E3E),
                          padding: EdgeInsets.only(
                            left: 48,
                            right: 64,
                            top: 16,
                            bottom: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Create Opportunity',
                          style: TextStyle(fontSize: 20),
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
