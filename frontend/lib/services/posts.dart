import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter/models/post.dart';
import 'package:twitter/services/user.dart';
import 'package:quiver/iterables.dart';

class PostService {
  List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PostModel(
        id: doc.id,
        text: doc.data()['text'] ?? '',
        creator: doc.data()['creator'] ?? '',
        timestamp: doc.data()['timestamp'] ?? 0,
        likesCount: doc.data()['likesCount'] ?? 0,
        retweetsCount: doc.data()['retweetsCount'] ?? 0,
        retweet: doc.data()['retweet'] ?? false,
        originalId: doc.data()['originalId'] ?? null,
      );
    }).toList();
  }

  PostModel _postFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.exists
        ? PostModel(
            id: snapshot.id,
            text: snapshot.data()['text'] ?? '',
            creator: snapshot.data()['creator'] ?? '',
            timestamp: snapshot.data()['timestamp'] ?? 0,
            likesCount: snapshot.data()['likesCount'] ?? 0,
            retweetsCount: snapshot.data()['retweetsCount'] ?? 0,
            retweet: snapshot.data()['retweet'] ?? false,
            originalId: snapshot.data()['originalId'] ?? null,
          )
        : null;
  }

  Future savePost(text) async {
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser.uid,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Future likePost(PostModel post, bool current) async {
    print(post.id);
    if (current) {
      post.likesCount = post.likesCount - 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .delete();
    }
    if (!current) {
      post.likesCount = post.likesCount + 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({});
    }
  }

  Future retweet(PostModel post, bool current) async {
    if (current) {
      post.retweetsCount = post.retweetsCount - 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("retweets")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection("posts")
          .where("originalId", isEqualTo: post.id)
          .where("creator", isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        if (value.docs.length == 0) {
          return;
        }
        FirebaseFirestore.instance
            .collection("posts")
            .doc(value.docs[0].id)
            .delete();
      });
      // Todo remove the retweet
      return;
    }
    post.retweetsCount = post.retweetsCount + 1;
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("retweets")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({});

    await FirebaseFirestore.instance.collection("posts").add({
      'creator': FirebaseAuth.instance.currentUser.uid,
      'timestamp': FieldValue.serverTimestamp(),
      'retweet': true,
      'originalId': post.id
    });
  }

  Stream<bool> getCurrentUserLike(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("likes")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  Stream<bool> getCurrentUserRetweet(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("retweets")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
  }

  Future<PostModel> getPostById(String id) async {
    DocumentSnapshot postSnap =
        await FirebaseFirestore.instance.collection("posts").doc(id).get();

    return _postFromSnapshot(postSnap);
  }

  Stream<List<PostModel>> getPostsByUser(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Future<List<PostModel>> getFeed() async {
    List<String> usersFollowing = await UserService() //['uid1', 'uid2']
        .getUserFollowing(FirebaseAuth.instance.currentUser.uid);

    var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);
    inspect(splitUsersFollowing);

    List<PostModel> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      inspect(splitUsersFollowing.elementAt(i));
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('creator', whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timestamp', descending: true)
          .get();

      feedList.addAll(_postListFromSnapshot(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timestamp;
      var bdate = b.timestamp;
      return bdate.compareTo(adate);
    });

    return feedList;
  }
}
