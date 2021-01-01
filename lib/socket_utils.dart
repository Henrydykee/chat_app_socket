
import 'dart:developer';
import 'dart:io';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:chat_app_socket/model/chat_message_model.dart';

import 'model/user.dart';

class SocketUtils {
  static String _serverIP = Platform.isIOS? 'http://localhost':'http://10.0.2.2';
  static const int SERVER_PORT = 6000;
  static String _connectUrl = '$_serverIP:$SERVER_PORT';

  //events
  static const String _ON_MESSAGE_RECEIVED = 'recieve_message';
  static const String _IS_USER_ONLINE_EVENT = 'check_online';
  static const String _EVENT_SINGLE_CHAT_MESSAGE = 'single_chat_message';

  //status
  static const int STATUS_MESSAGE_NOT_SENT = 10001;
  static const int STATUS_MESSAGE_SENT = 10002;

  //CHAT
  static const String SINGLE_CHAT = 'single_chat';

  User _fromUser;

  SocketIO _socket;
  SocketIOManager _manager;

  initSocket(User user) async {
    this._fromUser = user;
    log('connecting...${user.name}..');
    await _init();
  }

  _init() async {
    _manager = SocketIOManager();
    _socket = await _manager.createInstance(_socketOptions());
  }

  _socketOptions(){
    final Map<String,  String> userMap ={
      'from' : _fromUser.id.toString()
    };
    return SocketOptions(_connectUrl, enableLogging: true, transports: [Transports.WEB_SOCKET],query: userMap );
  }

  setOnConnectListener(Function onConnect){
    _socket.onConnect((data) {
      onConnect(data);
    });
  }

  setOnTimeOutListener(Function onTimeOut){
    _socket.onConnectTimeout((data) {
      onTimeOut(data);
    });
  }

  setOnConnectionError(Function onConnectionError){
    _socket.onConnectError((data) {
      onConnectionError(data);
    });
  }

  setOnErrorListener(Function onErrorListener ){
    _socket.onError((data) {
      onErrorListener(data);
    });
  }


  setOnDisconnectListener(Function onDisconnectListener){
    _socket.onDisconnect((data) {
      onDisconnectListener(data);
    });
  }

  closeConnect(){
    if(null != _socket){
      log("closing connection");
      _manager.clearInstance(_socket);
    }
  }

  connectToSocket(){
    if(null ==_socket){
      print('socket is null');
      return;
    }
    _socket.connect();
  }

  sendSingleChatMessage(ChatMessageModel chatMessageModel){
    if(null == _socket){
      log('Cannot send message');
      return;
    }
    _socket.emit(_EVENT_SINGLE_CHAT_MESSAGE, [
      chatMessageModel.toJson()
    ]);
  }
}