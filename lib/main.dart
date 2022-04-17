import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_sms_app/view/home_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:telephony/telephony.dart';

backgrounMessageHandler(SmsMessage? message) async {
  log("message1");

  log("message1  ${message!.body.toString()}");
}

void main() async {
  await GetStorage.init();
  Telephony telephony = Telephony.instance;
  telephony.listenIncomingSms(
    onNewMessage: (SmsMessage? message) {
      log("message2  ${message!.body.toString()}");
    },
    onBackgroundMessage: backgrounMessageHandler,
    listenInBackground: true,
  );

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeView(),
    );
  }
}
