import 'package:chat_app_socket/golbal.dart';
import 'package:chat_app_socket/model/chat_message_model.dart';
import 'package:chat_app_socket/model/user.dart';
import 'package:chat_app_socket/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatUserScreen extends StatefulWidget {
  @override
  _ChatUserScreenState createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  List<ChatMessageModel> chatMessage;
  List<User> _chatUser;

  @override
  void initState() {
    _chatUser = G.getUsersFor(G.loggedinUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("User List"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
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
