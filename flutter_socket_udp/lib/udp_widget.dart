import 'package:flutter/material.dart';

import 'plugins/udp/udp.dart';

class UdpWidget extends StatefulWidget {
  UdpWidget({Key? key}) : super(key: key);

  @override
  _UdpWidgetState createState() => _UdpWidgetState();
}

class _UdpWidgetState extends State<UdpWidget> {
  var _sender;
  String? _message;
  int? _dataLength;

  @override
  void initState() {
    super.initState();
    _inititialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("UDP"),
        ),
        body: Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text("message: $_message\nlength: $_dataLength",
                  textAlign: TextAlign.center),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: _commandButton("UR卡",
                      "{\"Tag\":\"animation\",\"Data\":{\"EffectFile\":\"ur\"}}")),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: _commandButton("CR卡",
                      "{\"Tag\":\"animation\",\"Data\":{\"EffectFile\":\"cr\"}}")),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: _commandButton("掌声",
                      "{\"Tag\":\"audio\",\"Data\":{\"EffectFile\":\"guzhang\"}}")),
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: _commandButton("欢呼",
                      "{\"Tag\":\"audio\",\"Data\":{\"EffectFile\":\"huanhu\"}}")),
            ])));
  }

  Widget _commandButton(String text, String command) {
    return TextButton(
        style: ButtonStyle(
          //圆角
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          //边框
          side: MaterialStateProperty.all(
            BorderSide(color: Color.fromRGBO(183, 183, 183, 1), width: 2),
          ),
          //背景
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Text(text),
        onPressed: () {
          setState(() {
            // _sendMessage("Hello World!");
            _sendMessage(command);
          });
        });
  }

  void _inititialize() async {
    _sender = await UDP.bind(Endpoint.any(port: Port(2000)));
  }

  void _sendMessage(String? message) async {
    _message = message;
    _dataLength = await _sender.send(
        message?.codeUnits, Endpoint.broadcast(port: Port(1000)));
  }
}

/*
  * command list:
  * {\"Tag\":\"health\",\"Data\":{\"Value\":5500,\"DataOwner\":\"left\"}}
  * {\"Tag\":\"card\",\"Data\":{\"Value\":29,\"DataOwner\":\"left\"}}
  * {\"Tag\":\"audio\",\"Data\":{\"EffectFile\":\"guzhang\"}}
  * {\"Tag\":\"animation\",\"Data\":{\"EffectFile\":\"cr\"}}
 */
