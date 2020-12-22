import 'package:flutter/material.dart';
import 'package:twitter/services/auth.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          FlatButton.icon(
              label: Text('SignOut'),
              icon: Icon(Icons.person),
              onPressed: () async {
                _authService.signOut();
              })
        ],
      ),
    );
  }
}
