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

  SocketIO socket;
  String statusSocket = 'none';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('status: $statusSocket', textAlign: TextAlign.center,),
            MaterialButton(
              child: Text(statusSocket == 'connect' ?
                'Disconnect' :
                'Start Connect'
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                if (statusSocket == 'none' || socket == null) {
                  _createSocket();
                } else {
                  _closeSocket();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  _createSocket() async {
    _closeSocket();

    try {
      socket = SocketIOManager().createSocketIO(
        'Domain',
        'Namespace',
        query: 'Query',
          socketStatusCallback: (String event) {
            debugPrint(event);
            setState(() => statusSocket = event);
          }
      );

      socket.init();
      socket.connect();
    } catch(e) {
      debugPrint(e);
      setState(() => statusSocket = 'local fail');
    }
  }

  _closeSocket() {
    if(socket == null) return;

    socket.disconnect();
    socket.destroy();
    if(mounted)
      setState(() {
        socket = null;
        statusSocket = 'none';
      });
    else
      socket = null;
  }

  @override
  void dispose() {
    _closeSocket();
    super.dispose();
  }
}
