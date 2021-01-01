import 'dart:developer';

import 'package:chat_app_socket/golbal.dart';
import 'package:chat_app_socket/model/chat_message_model.dart';
import 'package:chat_app_socket/model/user.dart';
import 'package:chat_app_socket/screens/chat_screen.dart';
import 'package:chat_app_socket/screens/login_screen.dart';
import 'package:flutter/material.dart';

class ChatUserScreen extends StatefulWidget {
  @override
  _ChatUserScreenState createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  List<ChatMessageModel> chatMessage;
  List<User> _chatUser;
  bool _connectedToSocket;
  String _connectMessage;


  @override
  void initState() {
    _connectedToSocket = false;
    _connectMessage = "Connecting..";
    _chatUser = G.getUsersFor(G.loggedinUser);
    super.initState();
    _connectToSocket();
  }

  _connectToSocket() async {
    log("connecting loggedin user ${G.loggedinUser.name} ,${G.loggedinUser.id}");
    G.initSocket();
   await G.socketUtils.initSocket(G.loggedinUser);
    G.socketUtils.connectToSocket();
    G.socketUtils.setOnConnectListener(onConnect);
    G.socketUtils..setOnConnectionError(onConnectionError);
    G.socketUtils.setOnTimeOutListener(onTimeOut);
    G.socketUtils.setOnDisconnectListener(onDisconnectListener);
    G.socketUtils.setOnErrorListener(onErrorListener);
  }

  onConnect(data){
    log("onConnect :${data}");
    setState(() {
      _connectedToSocket = true;
      _connectMessage ="connected";
    });
  }

  onConnectionError(data){
    log("onConnectionError :${data}");
    setState(() {
      _connectedToSocket = false;
      _connectMessage ="connection error";
    });
  }

  onTimeOut(data){
    log("onTimeOut :${data}");
    setState(() {
      _connectedToSocket = false;
      _connectMessage ="connection timeout";
    });
  }

  onDisconnectListener(data){
    log("onDisconnectListener :${data}");
    setState(() {
      _connectedToSocket = false;
      _connectMessage ="disconnected";
    });
  }

  onErrorListener(data){
    log("onErrorListener :${data}");
    setState(() {
      _connectedToSocket = false;
      _connectMessage ="connection error";
    });
  }

  @override
  void dispose() {
    G.socketUtils.closeConnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("User List"),
        actions: [
          IconButton(
              icon: Icon(Icons.close,color: Colors.white),
              onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    LoginScreen()), (Route<dynamic> route) => false);
              })
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            Text(_connectedToSocket ? 'connected' : _connectMessage ),
            Expanded(
                child: ListView.builder(
                    itemCount: _chatUser.length,
                    itemBuilder: (context, index) {
                      User user = _chatUser[index];
                      return GestureDetector(
                        onTap: (){
                          G.toChatUser = user;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatScreen()),
                          );
                        },
                        child: ListTile(
                          title: Text(user.name),
                          subtitle: Text(user.email),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
