
import 'package:chat_app_socket/golbal.dart';
import 'package:chat_app_socket/model/user.dart';
import 'package:flutter/material.dart';

import 'chat_user_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var _usernameController = TextEditingController();

  @override
  void initState() {
    _usernameController = TextEditingController();
    G.initDummyUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Let's Chat",style: TextStyle(
          color: Colors.black
        ),),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25,right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                filled: true,
                fillColor: Colors.white
              ),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                _loginTap();
              },
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(6.0))
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Login",style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                    ),),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _loginTap() {
    if (_usernameController.text.isEmpty){
      return ;
    }
    User me = G.dummyUser[0];
    if(_usernameController.text != "a"){
       me = G.dummyUser[1];
    }
    G.loggedinUser = me;
    _openChatUserScreen(context);
  }
  _openChatUserScreen(context) async {
    await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        ChatUserScreen()), (Route<dynamic> route) => false);
  }

}
