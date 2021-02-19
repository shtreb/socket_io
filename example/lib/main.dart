import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:socket_io/flutter_socket_io.dart';
import 'package:socket_io/socket_io_manager.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<SocketIO> sockets;
  String statusSocket = 'none';

  @override void initState() {
    sockets = [];
    super.initState();
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: Text(statusSocket, textAlign: TextAlign.center,)),
          Row(
            children: [
              MaterialButton(
                  child: Text('Start Connect'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _createSocket()
              ),
              MaterialButton(
                child: Text('Disconnect'),
                color: Theme.of(context).primaryColor,
                onPressed: () => _closeSocket(0),
              )
            ],
          )
        ],
      ),
    );
  }

  _createSocket() async {
    //_closeSocket();

    try {
      var socket = SocketIOManager().createSocketIO(
        //sockets.isEmpty ? 'https://api-qa.novakidschool.com' :
        'https://kshtreblev.novakidschool.com',
        '/socket.io/',
        query: 'classid=137129&teachercountry=Oman',
          socketStatusCallback: (String event) {
            debugPrint(event);
            setState(() => statusSocket += '\n$event ${sockets.last.getId()}');
          }
      );

      socket.init();
      socket.connect();
      sockets.add(socket);
    } catch(e) {
      debugPrint(e);
      setState(() => statusSocket += '\nlocal fail');
    }
  }

  _closeSocket(int id) {
    if(sockets.length == 0) return;
    if(sockets.length < id) return;

    String _id = sockets[id].getId();
    sockets[id].disconnect();
    sockets[id].destroy();
    sockets.removeAt(id);
    if(mounted)
      setState(() {
        statusSocket += '\nnone $_id';
      });
  }

  @override
  void dispose() {
    for(int i = 0; i < sockets.length; i++)
      _closeSocket(i);
    super.dispose();
  }
}
