import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:love_and_care/application/application.dart';
import 'package:love_and_care/core/network/network_info.dart';
import 'package:love_and_care/infrastructure/infrastucture.dart';
import 'package:love_and_care/presentation/presentation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (BuildContext context) =>
              UserBloc(UserRepositoryImpl(UserDataProvider())),
        ),
        BlocProvider<OpportunityBloc>(
          create: (BuildContext context) => OpportunityBloc(
            OpportunitRepositoryImpl(
              remoteDataProvider: OpportunityRemoteDataProvider(),
              localDataProvider: OpportunityLocalDataProvider(),
              networkInfo: NetworkInfoImpl(InternetConnectionChecker()),
            ),
            OpportunityGlobalState(opportunities: []),
          ),
        ),
        BlocProvider<CommentBloc>(
          create: (BuildContext context) => CommentBloc(
            CommentRepositoryImpl(
                remoteDataProvider: CommentRemoteDataProvider(),
                localDataProvider: CommentLocalDataProvider(),
                networkInfo: NetworkInfoImpl(InternetConnectionChecker())),
            CommentGlobalState(comments: []),
          ),
        ),
      ],
      child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Volunteer Management System',
          routerConfig: router),
    );
  }
}
