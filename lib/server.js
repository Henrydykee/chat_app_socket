var express = require('express');
var app = express();
var server =require('http').createServer(app);
var io = require('socket.io')(server);

//reserved events
let ON_CONNECTION = 'connection';
let ON_DISCONNECT = 'disconnection';

//main events
let EVENT_IS_USER_ONLINE = 'check_online';
let EVENT_SINGLE_CHAT_MESSAGE = 'single_chat_message';

//sub events
let SUB_EVENT_RECEIVE_MESSAGE ='receive_message';
let SUB_EVENT_IS_USER_CONNECTED ='is_user_connected';

PORT = 6000;
server.listen(PORT);
console.log(`server is running on port: ${PORT}`)

const userMap = new Map();

//status
let STATUS_MESSAGE_NOT_SENT = 10001;
let STATUS_MESSAGE_SENT = 10002;

io.sockets.on(ON_CONNECTION, function(socket){
    onEachUserConnection(socket);
});

function onEachUserConnection(socket){
    print('---------------------------');
    print('Connected socket:' + socket.id + 'User:'+ stringyfyToJson(socket.handshake.query))
}

function print(txt){
    console.log(txt);
}

function stringyfyToJson(data){
    return JSON.stringify(data)
}