import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String creator;
  final String text;
  final Timestamp timestamp;
  final String originalId;
  final bool retweet;

  int likesCount;
  int retweetsCount;

  PostModel(
      {this.id,
      this.creator,
      this.text,
      this.timestamp,
      this.likesCount,
      this.retweetsCount,
      this.originalId,
      this.retweet});
}
