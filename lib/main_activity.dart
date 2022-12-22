
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'loginUser.dart';

class MAinActivity extends StatelessWidget {
  final LoggedInUser loggedInUser;

  const MAinActivity({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(loggedInUser: loggedInUser),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final LoggedInUser loggedInUser;

  const MyHomePage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(loggedInUser: loggedInUser);
}

class _MyHomePageState extends State<MyHomePage> {
  final LoggedInUser loggedInUser;
  GlobalKey qrKey = GlobalKey();
  var qrText = "";
  late QRViewController controller;

  _MyHomePageState({required this.loggedInUser});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                qrText,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData as String;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
