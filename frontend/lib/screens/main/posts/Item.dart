import 'package:flutter/material.dart';
import 'package:twitter/models/post.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/services/posts.dart';

class ItemPost extends StatefulWidget {
  final PostModel post;
  final AsyncSnapshot<UserModel> snapshotUser;
  final AsyncSnapshot<bool> snapshotLike;
  final AsyncSnapshot<bool> snapshotRetweet;
  final bool retweet;

  ItemPost(this.post, this.snapshotUser, this.snapshotLike,
      this.snapshotRetweet, this.retweet,
      {Key key})
      : super(key: key);

  @override
  _ItemPostState createState() => _ItemPostState();
}

class _ItemPostState extends State<ItemPost> {
  PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.snapshotRetweet.data || widget.retweet)
                Text("Retweet"),
              SizedBox(height: 20),
              Row(
                children: [
                  widget.snapshotUser.data.profileImageUrl != ''
                      ? CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              widget.snapshotUser.data.profileImageUrl))
                      : Icon(Icons.person, size: 40),
                  SizedBox(width: 10),
                  Text(widget.snapshotUser.data.name)
                ],
              ),
            ],
          )),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.post.text),
                SizedBox(height: 20),
                Text(widget.post.timestamp.toDate().toString()),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: new Icon(
                                widget.snapshotRetweet.data
                                    ? Icons.cancel
                                    : Icons.repeat,
                                color: Colors.blue,
                                size: 30.0),
                            onPressed: () => _postService.retweet(
                                widget.post, widget.snapshotRetweet.data)),
                        Text(widget.post.retweetsCount.toString())
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            icon: new Icon(
                                widget.snapshotLike.data
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.blue,
                                size: 30.0),
                            onPressed: () {
                              _postService.likePost(
                                  widget.post, widget.snapshotLike.data);
                            }),
                        Text(widget.post.likesCount.toString())
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
