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
    _initSocketListeners();
  }


  _checkOnline(){
    ChatMessageModel chatMessageModel = ChatMessageModel(
        chatId: 0,
        to: _toChatUser.id,
        from: G.loggedinUser.id,
        toUserOnlineStatus: false,
        message: _chatTextController.text,
        chatType: SocketUtils.SINGLE_CHAT);
    G.socketUtils.checkOnline(chatMessageModel);
  }

  _initSocketListeners() async {
    G.socketUtils.setOnChatMessageReceiveListener(onChatMessageReceived);
    G.socketUtils.setOnlineUserStatusListener(onUserStatus);
  }

  onUserStatus(data){
    log('User status ${data}');
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    if(chatMessageModel.toUserOnlineStatus){
      _userOnlineStatus = UserOnlineStatus.online;
    }
  }

  onChatMessageReceived(data){
    log('onChatMessageReceieved:'+ data);
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    chatMessageModel.fromMe = false;
    processMessage(chatMessageModel);
  }

  processMessage(chatMessageModel){
    setState(() {
      chatMessage.add(chatMessageModel);
    });
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
                      bool fromMe = chatmessage.fromMe;
                      return ListTile(
                        title: Container(
                          alignment: fromMe? Alignment.centerRight : Alignment.centerLeft,
                          margin: EdgeInsets.all(10),
                          color: fromMe ? Colors.green : Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(chatmessage.message,style: TextStyle(color: Colors.black),),
                            )
                        ),
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
    log('sending message to ${_toChatUser.name}');
    ChatMessageModel chatMessageModel = ChatMessageModel(
        chatId: 0,
        to: _toChatUser.id,
        from: G.loggedinUser.id,
        toUserOnlineStatus: false,
        message: _chatTextController.text,
        fromMe: true,
        chatType: SocketUtils.SINGLE_CHAT);
    processMessage(chatMessageModel);
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
