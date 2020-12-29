
import 'package:chat_app_socket/model/user.dart';
import 'package:flutter/material.dart';


enum UserOnlineStatus{
  connecting,
  online,
  not_online
}

class ChatTitle extends StatelessWidget {

  const ChatTitle({Key key, @required this.chatUser, @required this.userOnlineStatus });

  final User chatUser;
  final UserOnlineStatus userOnlineStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(chatUser.name),
          Text("${_getStatusText()}",style: TextStyle(
            fontSize: 14,
            color: Colors.white70
          ),)
        ],
      ),
    );
  }

  _getStatusText(){
    if(userOnlineStatus == UserOnlineStatus.connecting){
      return "Connecting";
    } else if (userOnlineStatus == UserOnlineStatus.online){
      return "Online";
    }
    return "Offline";
  }
}
