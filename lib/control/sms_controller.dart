import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mysql1/mysql1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';

class SmSController extends GetxController {
  SmsQuery query = SmsQuery();

  final box = GetStorage();
  var isLoading = false.obs;
  var messages = <SmsMessage>[].obs;
  var isReaData = <String>[].obs;
  var insertSqlData = <String>[].obs;
  var mylist = <String>[].obs;
  var isloadingSetData = false.obs;
  var switchVlaue = false.obs;
  var permission = false.obs;

  PermissionStatus permissionStatus = PermissionStatus.denied;
  List<String> test = [
    "Lorem Ipsum is simply 0",
    "Lorem Ipsum is simply 1",
    "Lorem Ipsum is simply 1000",
    "Lorem Ipsum is simply 3000",
    "Lorem Ipsum is simply 7",
    "Lorem Ipsum is simply 5000",
    "Lorem Ipsum is simply 2000",
    "Lorem Ipsum is simply 1",
    "Lorem Ipsum is simply 9",
  ];
  @override
  void onReady() {
    getInboxSms();
    getmySQLData();
    connectDatabaseValue();
    super.onReady();
  }

  Future<void> getInboxSms() async {
    isLoading.value = true;
    permissionStatus = await Permission.sms.status;
    if (!permissionStatus.isGranted) {
      Future.delayed(const Duration(seconds: 2), () async {
        await Permission.sms.request();
      });
    } else if (permissionStatus.isGranted) {
      await Permission.sms.request();
      messages.value = await query.querySms(kinds: [SmsQueryKind.Inbox]);
      messagesIsRead();
    }
    isLoading.value = false;
    update();
    refresh();
  }

  void connectDatabase() async {
    switchVlaue.value = !switchVlaue.value;
    await box.write('key', switchVlaue.value);
  }

  void connectDatabaseValue() {
    switchVlaue.value = box.read('key') ?? false;
    log('switchVlaue $switchVlaue.value');
  }

  void messagesIsRead() {
    insertSqlData.value = [];
    for (var value in messages) {
      insertSqlData.addAll([
        "Address: ${value.address.toString()} , Body: ${value.body.toString()} , DateTime: ${value.toString().substring(0, 16)}"
      ]);
    }
  }

  bool? isReadMessage(String data) {
    bool result = mylist.contains(data);
    return result;
  }

  static String host = '154.0.171.145',
      user = 'halvelsv_Dev',
      password = 'Developer123',
      db = 'halvelsv_Sms';
  static int port = 3306;

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);

    return await MySqlConnection.connect(settings);
  }

  Future<List<String>> getmySQLData() async {
    var db = getConnection();
    String sql = 'select * from halvelsv_Sms.TblMahmoud;';

    await db.then((conn) async {
      await conn.query(sql).then((results) {
        String text = '';
        log("data ${results.fields}");
        mylist.value = [];
        for (var res in results) {
          text = res['txtSmsText'].toString();
          mylist.add(text);
        }
      }).onError((error, stackTrace) {
        print(error);

        return null;
      });

      conn.close();
    });
    return mylist;
  }

  Future<void> setmySQLData(BuildContext context) async {
    isloadingSetData(true);
    var db = getConnection();
    String sql =
        'insert into TblMahmoud (txtSmsText) values (?) ON DUPLICATE KEY UPDATE txtSmsText=txtSmsText';
    showToast(
      'The process may take some time',
      context: context,
      animation: StyledToastAnimation.scale,
      backgroundColor: Colors.orangeAccent,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.center,
      animDuration: const Duration(seconds: 2),
      duration: const Duration(seconds: 4),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
    );
    await Future.delayed(const Duration(seconds: 1), () {
      test.removeWhere((e) => mylist.contains(e));
    });
    List<String> result = test;
    log("result $result");
    if (result.isNotEmpty || result.length > 0) {
      await db.then((conn) async {
        for (var value in test) {
          await conn.transaction((db) async {
            return await db.query(
              sql, [value],
              //insertSqlData
            );
          });
        }
        conn.close();
      }).then((value) {
        showToast(
          'The task has been completed successfully',
          context: context,
          animation: StyledToastAnimation.scale,
          backgroundColor: Colors.blueAccent,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.center,
          animDuration: const Duration(seconds: 1),
          duration: const Duration(seconds: 4),
          curve: Curves.elasticOut,
          reverseCurve: Curves.linear,
        );
      }).catchError((onError) {
        showToast(
          'onError',
          context: context,
          animation: StyledToastAnimation.scale,
          backgroundColor: Colors.blueAccent,
          reverseAnimation: StyledToastAnimation.fade,
          position: StyledToastPosition.center,
          animDuration: const Duration(seconds: 1),
          duration: const Duration(seconds: 4),
          curve: Curves.elasticOut,
          reverseCurve: Curves.linear,
        );
      });
    }

    isloadingSetData(false);
  }
}
