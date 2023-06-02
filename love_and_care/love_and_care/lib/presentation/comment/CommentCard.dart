import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:love_and_care/application/application.dart';
import 'package:love_and_care/domain/domain.dart';


class CommentCard extends StatelessWidget {
  const CommentCard(
      {Key? key,
      required this.comment,
      required this.username,
      required this.onEdit})
      : super(key: key);

  final Comment comment;
  final String username;
  final void Function(Comment? comment) onEdit;

  @override
  Widget build(BuildContext context) {
    String timeAgo = getTimeAgo(comment.date);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                height: comment.username == username ? 8 : 0,
              ),
              CircleAvatar(
                child: Text(
                  comment.username[0].toUpperCase(),
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (comment.username == username)
                      IntrinsicWidth(
                        child: PopupMenuButton<String>(
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ];
                          },
                          onSelected: (value) {
                            if (value == 'edit') {
                              // Handle edit option
                              onEdit(comment);
                            } else if (value == 'delete') {
                              // Handle delete option
                              onEdit(null);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirmation'),
                                    content: Text(
                                        'Are you sure you want to delete this comment?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Handle cancel button press
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          BlocProvider.of<CommentBloc>(context)
                                              .add(DeleteComment(
                                                  id: comment.id));
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: comment.username == username ? 0 : 8,
                ),
                Text(comment.comment),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getTimeAgo(DateTime time) {
    final now = DateTime.now();
    return timeago.format(now.subtract(now.difference(time)));
  }
}
