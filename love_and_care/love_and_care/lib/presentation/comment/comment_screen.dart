import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:love_and_care/application/application.dart';
import 'package:love_and_care/domain/domain.dart';
import 'package:love_and_care/presentation/presentation.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  final String username;

  const ChatScreen({required this.id, required this.username});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late CommentBloc _commentBloc;
  final _commentController = TextEditingController();
  Comment? _selectedComment;
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    // _commentBloc = CommentBloc(CommentRepository(), CommentGlobalState());
    _commentBloc = BlocProvider.of<CommentBloc>(context);
    _commentBloc.add(GetComments(id: widget.id));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentSuccess) {
          final newComments = state.globalState.comments;
          if (!listEquals(_comments, newComments)) {
            setState(() {
              _comments = newComments;
            });
          }
        }
      },
      bloc: _commentBloc,
      builder: (context, state) {
        if (state is CommentLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CommentSuccess) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = state.globalState.comments[index];
                    return CommentCard(
                      comment: comment,
                      username: widget.username,
                      onEdit: (comment) {
                        if (comment != null) {
                          setState(() {
                            _selectedComment = comment;
                            _commentController.text = comment.comment;
                          });
                        } else {
                          _selectedComment = comment;
                          _commentController.text = "";
                        }
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Enter your comment',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        final comment = _commentController.text;
                        if (comment.isNotEmpty) {
                          if (_selectedComment != null) {
                            // Edit existing comment
                            _commentBloc.add(UpdateComment(
                                comment: new Comment(
                                    id: _selectedComment!.id,
                                    opportunityId:
                                        _selectedComment!.opportunityId,
                                    username: _selectedComment!.username,
                                    comment: comment,
                                    date: _selectedComment!.date)));
                            setState(() {
                              _selectedComment = null;
                              _commentController.clear();
                            });
                          } else {
                            // Create new comment
                            _commentBloc.add(CreateComment(
                              opportunityId: widget.id,
                              comment: comment,
                            ));
                            _commentController.clear();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(
                            0xFFB73E3E), // Set the background color to red
                        padding: const EdgeInsets.all(
                            22.0), // Add padding to the button
                      ),
                      child: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (state is CommentFailure) {
          return Center(
            child: Text('Failed to load comments: ${state.errorMessage}'),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
