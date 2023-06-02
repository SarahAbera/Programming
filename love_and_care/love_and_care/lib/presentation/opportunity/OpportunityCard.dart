import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:love_and_care/application/application.dart';
import 'package:love_and_care/domain/domain.dart';

class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final String currentUserUsername;

  const OpportunityCard({
    Key? key,
    required this.opportunity,
    required this.currentUserUsername,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLiked = opportunity.likes.contains(currentUserUsername);
    final bool isParticipating =
        opportunity.participants.contains(currentUserUsername);

    final route = ModalRoute.of(context);
    final routeSettings = route?.settings;
    final currentPath = routeSettings?.name;

    final routeArguments = routeSettings?.arguments;

// Extract the value of "role" from route arguments
    final String? role = (routeArguments as Map<String, dynamic>?)?['role'];

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context)
                        .push('/opportunity/${opportunity.opportunityId}');
                  },
                  child: Text(
                    opportunity.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB73E3E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(opportunity.description),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.date_range,
                  // color: Color(0xFFB73E3E),
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM d, yyyy').format(opportunity.date),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  // color: Color(0xFFB73E3E),
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat.Hm().format(opportunity.date),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  // color: Color(0xFFB73E3E),
                ),
                const SizedBox(width: 4),
                Text(
                  opportunity.location,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    final opportunityBloc =
                        BlocProvider.of<OpportunityBloc>(context);
                    opportunityBloc.add(LikeOpportunity(
                      id: opportunity.opportunityId,
                      path: role == null ? currentPath! : role,
                    ));
                  },
                  child: BlocBuilder<OpportunityBloc, OpportunityState>(
                    builder: (context, state) {
                      if (state is OpportunityLikeLoading &&
                          state.id == opportunity.opportunityId) {
                        // return Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 6, horizontal: 12),
                        //   child: CircularProgressIndicator(
                        //     strokeWidth: 2,
                        //   ),
                        // );
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isLiked ? Color(0xFFB73E3E) : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isLiked
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_outlined,
                                color:
                                    isLiked ? Color(0xFFB73E3E) : Colors.black,
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 9,
                                height: 9,
                                child: CircularProgressIndicator(),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Likes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isLiked
                                      ? Color(0xFFB73E3E)
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isLiked ? Color(0xFFB73E3E) : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isLiked
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_outlined,
                                color:
                                    isLiked ? Color(0xFFB73E3E) : Colors.black,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                opportunity.totalLikes.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isLiked
                                      ? Color(0xFFB73E3E)
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Likes',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isLiked
                                      ? Color(0xFFB73E3E)
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(onTap: () {
                  final opportunityBloc =
                      BlocProvider.of<OpportunityBloc>(context);
                  opportunityBloc.add(ParticipateOpportunity(
                      id: opportunity.opportunityId,
                      path: role == null ? currentPath! : role));
                }, child: BlocBuilder<OpportunityBloc, OpportunityState>(
                    builder: (context, state) {
                  if (state is OpportunityParticipateLoading &&
                      state.id == opportunity.opportunityId) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        // color: isParticipating ? Color(0xFFB73E3E) : null,
                        border: Border.all(
                            color: isParticipating
                                ? Color(0xFFB73E3E)
                                : Colors.black),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: isParticipating
                                ? Color(0xFFB73E3E)
                                : Colors.black,
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 9,
                            height: 9,
                            child: CircularProgressIndicator(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Participates',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isParticipating
                                  ? Color(0xFFB73E3E)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        // color: isParticipating ? Color(0xFFB73E3E) : null,
                        border: Border.all(
                            color: isParticipating
                                ? Color(0xFFB73E3E)
                                : Colors.black),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: isParticipating
                                ? Color(0xFFB73E3E)
                                : Colors.black,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            opportunity.totalParticipants.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isParticipating
                                  ? Color(0xFFB73E3E)
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Participates',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isParticipating
                                  ? Color(0xFFB73E3E)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                })),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
