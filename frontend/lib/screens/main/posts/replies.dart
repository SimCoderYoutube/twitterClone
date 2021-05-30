import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/models/post.dart';
import 'package:twitter/screens/main/posts/list.dart';
import 'package:twitter/services/posts.dart';

class Replies extends StatefulWidget {
  Replies({Key key}) : super(key: key);

  @override
  _RepliesState createState() => _RepliesState();
}

class _RepliesState extends State<Replies> {
  PostService _postService = PostService();
  String text = '';
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PostModel args = ModalRoute.of(context).settings.arguments;
    return FutureProvider.value(
        value: _postService.getReplies(args),
        child: Container(
          child: Scaffold(
            body: Container(
              child: Column(
                children: [
                  Expanded(child: ListPosts(args)),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Form(
                            child: TextFormField(
                          controller: _textController,
                          onChanged: (val) {
                            setState(() {
                              text = val;
                            });
                          },
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                            textColor: Colors.white,
                            color: Colors.blue,
                            onPressed: () async {
                              await _postService.reply(args, text);
                              _textController.text = '';
                              setState(() {
                                text = '';
                              });
                            },
                            child: Text("Reply"))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
