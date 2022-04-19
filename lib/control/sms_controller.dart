import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mysql1/mysql1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:telephony/telephony.dart' as tel;

class SmSController extends GetxController {
  SmsQuery query = SmsQuery();
  tel.Telephony? telephony;

  final box = GetStorage();
  var isLoading = false.obs;
  var messages = <SmsMessage>[].obs;
  var isReaData = <String>[].obs;
  var insertSqlData = <String>[].obs;
  var mylist = <String>[].obs;
  var isloadingSetData = false.obs;
  var switchVlaue = false.obs;
  var permissioncheck = false.obs;
  static String sqlInsert =
      'insert into TblMahmoud (txtSmsText) values (?) ON DUPLICATE KEY UPDATE txtSmsText=txtSmsText';
  static String sql = 'select * from halvelsv_Sms.TblMahmoud;';

  Rx<PermissionStatus> permissionStatus = (PermissionStatus.limited).obs;
  @override
  void onInit() {
    getmySQLData();
    connectDatabaseValue();
    checkPermission();
    super.onInit();
  }

  Future<void> checkPermission() async {
    permissionStatus.value = await Permission.sms.request();
    if (permissionStatus.value.isGranted) {
      getInboxSms();
    } else if (permissionStatus.value.isPermanentlyDenied) {
      openAppSettings();
      Get.snackbar(
        "Setting access",
        "You must grant access to a message box",
        icon: const Icon(Icons.error, color: Colors.redAccent),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
      );
    } else if (permissionStatus.value.isDenied) {
      permissionStatus.value = await Permission.sms.request();
    }

    listeners;
  }

  Future<void> getInboxSms() async {
    await Permission.sms.request().then((value) {
      permissionStatus.value = value;
    });
    messages.value = await query.querySms(kinds: [SmsQueryKind.Inbox]);
    listeners;
    update();
  }

  void connectDatabase() async {
    switchVlaue.value = !switchVlaue.value;
    await box.write('key', switchVlaue.value);
  }

  void connectDatabaseValue() {
    switchVlaue.value = box.read('key') ?? false;
  }

  void messagesIsRead() {
    insertSqlData.value = [];
    for (var value in messages) {
      insertSqlData.addAll([
        "Address: ${value.address.toString()} | Body: ${value.body.toString()} | DateTime: ${value.dateSent.toString()}"
      ]);
    }
  }

  bool? isReadMessage(String data) {
    bool result = mylist.contains(data.toString());
    log("mylist $mylist");
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
        Get.snackbar(
          "Connection timed",
          "$error",
          icon: const Icon(Icons.error, color: Colors.redAccent),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
        );

        return null;
      });

      conn.close();
    });
    return mylist;
  }

  Future<void> setmySQLData(BuildContext context) async {
    isloadingSetData(true);
    var db = getConnection();

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
    List<String> result = [];
    await Future.delayed(const Duration(seconds: 2), () {
      messages.removeWhere((e) => mylist.contains(
          "Address: ${e.address.toString()} | Body: ${e.body.toString()} | DateTime: ${e.dateSent.toString()}"));

      for (var v in messages) {
        result.addAll([
          "Address: ${v.address.toString()} | Body: ${v.body.toString()} | DateTime: ${v.dateSent.toString()}"
        ]);
      }
    });
    if (result.isNotEmpty || result.length > 0) {
      await db.then((conn) async {
        for (var value in result) {
          await conn.transaction((db) async {
            return await db.query(
              sqlInsert,
              [value],
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
          '$onError',
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

  Future<void> insertSmsInBackground({tel.SmsMessage? message}) async {
    var db = getConnection();

    db.then((value) async {
      if (message != null) {
        value.query(sqlInsert, [
          "Address: ${message.address.toString()} | Body: ${message.body.toString()} | DateTime: ${DateTime.now().toString().substring(0, 16)}"
        ]);
      }
    });
  }
}
