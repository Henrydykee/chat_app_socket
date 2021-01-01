var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);

//reserved events
let ON_CONNECTION = 'connection';
let ON_DISCONNECT = 'disconnection';

//main events
let EVENT_IS_USER_ONLINE = 'check_online';
let EVENT_SINGLE_CHAT_MESSAGE = 'single_chat_message';

//sub events
let SUB_EVENT_RECEIVE_MESSAGE = 'receive_message';
let SUB_EVENT_IS_USER_CONNECTED = 'is_user_connected';

PORT = 6000;
server.listen(PORT);
console.log(`server is running on port: ${PORT}`)

const userMap = new Map();

//status
let STATUS_MESSAGE_NOT_SENT = 10001;
let STATUS_MESSAGE_SENT = 10002;

io.sockets.on(ON_CONNECTION, function (socket) {
    onEachUserConnection(socket);
});


function onEachUserConnection(socket) {
    print('---------------------------');
    print('Connected socket:' + socket.id + 'User:' + stringyfyToJson(socket.handshake.query));
    var from_user_id = socket.handshake.query;
    let userMapVal = {socket_id: socket.id};
    addUserToMap(from_user_id, userMapVal);
    printOnlineUsers();
    print(userMap);
    onMessage(socket);
    onDisconnet(socket);
}

function onMessage(socket){
    socket.on(SUB_EVENT_RECEIVE_MESSAGE, function(chat_message){
        singleChatHandler(socket,chat_message)
    })
}

function singleChatHandler(socket, chat_message){
    print('ON_MESSAGE' + stringyfyToJson(chat_message));
    let to_user_id = chat_message.to;
    let from_user_id = chat_message.from;
    print(from_user_id + '=>' + to_user_id);
    let to_user_socket_id = getSocketIDFromMapForThisUser(to_user_id);
    if(to_user_socket_id == undefined){
        print('chat user not connected');
        chat_message.to_user_online_status = false
        return;
    }

    chat_message.to_user_online_status = true;
    sendToConnectedSocket(socket, to_user_socket_id, SUB_EVENT_RECEIVE_MESSAGE, chat_message);
}

function sendToConnectedSocket(socket, to_user_socket_id, event, chat_message){
    socket.to(`${to_user_socket_id}`).emit(event,stringyfyToJson(chat_message));
}

function getSocketIDFromMapForThisUser(to_user_id){
    let  userMapVal = userMap.get(`${to_user_id}`);
    if(undefined == userMapVal){
        return undefined
    }
    return userMapVal.socket_id
}

function addUserToMap(key_user_id, socket_id){
    userMap.set(key_user_id, socket_id);
}

function printOnlineUsers(){
    print('online users:' + userMap.size)
}

function onDisconnet(socket) {
    socket.on(ON_DISCONNECT, function () {
        print('Disconnected' + socket.id)
        socket.removeAllListeners(ON_DISCONNECT);
    })
}


function print(txt) {
    console.log(txt);
}


function stringyfyToJson(data) {
    return JSON.stringify(data)
}