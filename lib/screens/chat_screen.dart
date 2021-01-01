import 'dart:developer';

import 'package:chat_app_socket/golbal.dart';
import 'package:chat_app_socket/model/chat_message_model.dart';
import 'package:chat_app_socket/model/user.dart';
import 'package:chat_app_socket/socket_utils.dart';
import 'package:chat_app_socket/widgets/chat_title.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessageModel> chatMessage;
  User _toChatUser;
  UserOnlineStatus _userOnlineStatus;

  TextEditingController _chatTextController;

  @override
  void initState() {
    chatMessage = List();
    _chatTextController = TextEditingController();
    _toChatUser = G.toChatUser;
    _userOnlineStatus = UserOnlineStatus.connecting;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ChatTitle(
            userOnlineStatus: _userOnlineStatus,
            chatUser: G.toChatUser,
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.blue,
                ),
                onPressed: () {})
          ],
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: chatMessage.length,
                    itemBuilder: (context, index) {
                      ChatMessageModel chatmessage = chatMessage[index];
                      return ListTile(
                        title: Text(chatmessage.message),
                      );
                    }),
              ),
              _buttomChatArea()
            ],
          ),
        ));
  }

  _buttomChatArea() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          _chatTextArea(),
          IconButton(
            onPressed: () {
              _sendMessageBtnTap();
            },
            icon: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }

  _sendMessageBtnTap() async {
    if (_chatTextController.text.isEmpty) {
      return;
    }
    log('sending message to ${_toChatUser.name}')
    ChatMessageModel chatMessageModel = ChatMessageModel(
        chatId: 0,
        to: _toChatUser.id,
        from: G.loggedinUser.id,
        toUserOnlineStatus: false,
        message: _chatTextController.text,
        chatType: SocketUtils.SINGLE_CHAT);
    G.socketUtils.sendSingleChatMessage(chatMessageModel);
  }

  _chatTextArea() {
    return Expanded(
        child: TextField(
      controller: _chatTextController,
      decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.all(10.0),
          hintText: "Type message"),
    ));
  }
}
