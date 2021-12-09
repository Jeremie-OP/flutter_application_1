import 'package:flutter/material.dart';

class CommentModel {
  String user = '';
  String comment = '';
  int note;

  CommentModel({required this.user, required this.comment, required this.note});
}

class CommentsList extends StatelessWidget {
  var comments;
  CommentsList({Key? key, this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ExpansionTile(
        leading: Icon(Icons.comment),
        trailing: Text("un certain nombre"),
        title: Text("Commentaires"),
        children: List<Widget>.generate(
            comments.length, (int index) => _SingleComment()),
      ),
    );
  }
}

class _SingleComment extends StatelessWidget {
  const _SingleComment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
