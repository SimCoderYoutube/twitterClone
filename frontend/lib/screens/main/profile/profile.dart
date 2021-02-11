import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/models/user.dart';
import 'package:twitter/screens/main/posts/list.dart';
import 'package:twitter/services/posts.dart';
import 'package:twitter/services/user.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PostService _postService = PostService();
  UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider.value(
            value: _postService
                .getPostsByUser(FirebaseAuth.instance.currentUser.uid),
          ),
          StreamProvider.value(
            value:
                _userService.getUserInfo(FirebaseAuth.instance.currentUser.uid),
          )
        ],
        child: Scaffold(
            body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverAppBar(
                    floating: false,
                    pinned: true,
                    expandedHeight: 130,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Image.network(
                      Provider.of<UserModel>(context).bannerImageUrl ?? '',
                      fit: BoxFit.cover,
                    )),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(
                                  Provider.of<UserModel>(context)
                                          .profileImageUrl ??
                                      '',
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/edit');
                                    },
                                    child: Text("Edit Profile"))
                              ]),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                Provider.of<UserModel>(context).name ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ]))
                ];
              },
              body: ListPosts()),
        )));
  }
}
