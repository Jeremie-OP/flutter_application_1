import 'package:flutter/material.dart';

class CommentModel {
  String user = '';
  String comment = '';
  int note;

  CommentModel({required this.user, required this.comment, required this.note});
}

class CommentsList extends StatelessWidget {
  List<CommentModel> comments;
  CommentsList({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ExpansionTile(
        leading: Icon(Icons.comment),
        trailing: Text(comments.length.toString()),
        title: Text("Commentaires"),
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            controller: ScrollController(),
            scrollDirection: Axis.vertical,
            itemCount: comments.length,
            itemBuilder: (BuildContext context, int index) {
              return _SingleComment(comment: comments[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _SingleComment extends StatelessWidget {
  CommentModel comment;
  _SingleComment({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(comment.user),
          Text(comment.comment),
          Text(comment.note.toString()),
        ],
      ),
    );
  }
}
