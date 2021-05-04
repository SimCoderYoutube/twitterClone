import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String creator;
  final String text;
  final Timestamp timestamp;
  int likesCount;

  PostModel(
      {this.id, this.creator, this.text, this.timestamp, this.likesCount});
}
