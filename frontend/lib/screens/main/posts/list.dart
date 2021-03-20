import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/models/post.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/services/user.dart';

class ListPosts extends StatefulWidget {
  ListPosts({Key key}) : super(key: key);

  @override
  _ListPostsState createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  UserService _userService = UserService();
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<PostModel>>(context) ?? [];

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return StreamBuilder(
            stream: _userService.getUserInfo(post.creator),
            builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListTile(
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(
                    children: [
                      snapshot.data.profileImageUrl != ''
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(snapshot.data.profileImageUrl))
                          : Icon(Icons.person, size: 40),
                      SizedBox(width: 10),
                      Text(snapshot.data.name)
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.text),
                          SizedBox(height: 20),
                          Text(post.timestamp.toDate().toString())
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              );
            });
      },
    );
  }
}
