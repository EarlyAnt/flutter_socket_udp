import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_socket_udp/plugins/udp/udp.dart';

import 'plugins/udp/udp.dart';

class UdpWidget extends StatefulWidget {
  UdpWidget({Key? key}) : super(key: key);

  @override
  _UdpWidgetState createState() => _UdpWidgetState();
}

class _UdpWidgetState extends State<UdpWidget> {
  UDP? _sender;
  String? _message;
  int? _dataLength;
  List<String> _images = ["assets/4.jpg", "assets/5.jpg", "assets/6.jpg"];
  String _imagePath = "assets/3.jpg";

  @override
  void initState() {
    super.initState();
    _inititialize();
  }

  @override
  Widget build(BuildContext context) {
    Size screeenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("UDP"), centerTitle: true),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Container(
                      // color: Colors.lightGreenAccent,
                      child: Image.asset(_imagePath,
                          width: screeenSize.width * 0.9,
                          height: screeenSize.height * 0.09))),
              Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text("message: $_message\nlength: $_dataLength",
                      textAlign: TextAlign.center)),
              Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Wrap(
                      spacing: 30,
                      children: _images.map((e) => _imageButton(e)).toList())),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 50,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: _commandButton("UR卡",
                            "{\"Tag\":\"animation\",\"Data\":{\"EffectFile\":\"ur\"}}")),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: _commandButton("CR卡",
                            "{\"Tag\":\"animation\",\"Data\":{\"EffectFile\":\"cr\"}}")),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: _commandButton("掌声",
                            "{\"Tag\":\"audio\",\"Data\":{\"EffectFile\":\"guzhang\"}}")),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: _commandButton("欢呼",
                            "{\"Tag\":\"audio\",\"Data\":{\"EffectFile\":\"huanhu\"}}")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            minimumSize: MaterialStateProperty.all(Size(100, 20))),
        child: Text(text),
        onPressed: () {
          setState(() {
            // _sendMessage("Hello World!");
            _sendStringMessage(command);
          });
        });
  }

  Widget _imageButton(String imagePath) {
    return IconButton(
        icon: Image.asset(imagePath),
        iconSize: 48,
        onPressed: () {
          _sendImage(imagePath);
        });
  }

  void _inititialize() async {
    _sender = await UDP.bind(Endpoint.any(port: Port(2000)));
  }

  void _sendStringMessage(String? message) async {
    _message = message;
    print(message);
    _dataLength = await _sender?.send(
        message!.codeUnits, Endpoint.broadcast(port: Port(1000)));
  }

  void _sendRawdataMessage(List<int>? message) async {
    _message = "byte data";
    _dataLength =
        await _sender?.send(message!, Endpoint.broadcast(port: Port(3000)));
    print("raw data length: $_dataLength");
  }

  void _sendImage(String? imagePath) async {
    // String dataString = await _getImageData(imagePath);
    // // print(dataString.toString());
    // _sendStringMessage(
    //     "{\"Tag\":\"avatar\",\"Data\":{\"Bytes\":\"$dataString\"}}");

    List<int> imageRawData = await _getImageRawData(imagePath!);
    _sendRawdataMessage(imageRawData);
  }

  Future<String> _getImageData(String? imagePath) async {
    var image = await rootBundle.load(imagePath ?? "");
    var bytes =
        image.buffer.asUint8List(image.offsetInBytes, image.lengthInBytes);
    var list = bytes.toList();
    String dataString = list.join(',');
    // print("length: ${dataString.length}, data: $dataString");
    return dataString;
  }

  Future<List<int>> _getImageRawData(String? imagePath) async {
    var image = await rootBundle.load(imagePath ?? "");
    var bytes =
        image.buffer.asUint8List(image.offsetInBytes, image.lengthInBytes);
    var list = bytes.toList();
    return list;
  }
}

/*
  * command list:
  * {\"Tag\":\"health\",\"Data\":{\"Value\":5500,\"DataOwner\":\"left\"}}
  * {\"Tag\":\"card\",\"Data\":{\"Value\":29,\"DataOwner\":\"left\"}}
  * {\"Tag\":\"audio\",\"Data\":{\"EffectFile\":\"guzhang\"}}
  * {\"Tag\":\"animation\",\"Data\":{\"EffectFile\":\"cr\"}}
  * {\"Tag\":\"avatar\",\"Data\":{\"Bytes\":\"255,216,255,224,0,16,74,70,73,70,...\"}}
 */
