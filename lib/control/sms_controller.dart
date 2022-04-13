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
  var isloadingSetData = false.obs;
  var switchVlaue = false.obs;
  var permission = false.obs;
  PermissionStatus permissionStatus = PermissionStatus.denied;

  @override
  void onReady() {
    getInboxSms();
    connectDatabaseValue();
    super.onReady();
  }

  void getInboxSms() async {
    isLoading.value = true;
    permissionStatus = await Permission.sms.status;
    if (!permissionStatus.isGranted) {
      await Permission.sms.request();
    } else if (permissionStatus.isGranted) {
      messages.value = await query.getAllSms;
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
    final List<String> mylist = [];
    await db.then((conn) async {
      await conn.query(sql).then((results) {
        String text = '';
        log("data ${results.fields}");
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
    log("list {$mylist}");
    return mylist;
  }

  Future<void> setmySQLData(BuildContext context) async {
    isloadingSetData(true);
    var db = getConnection();
    String sql =
        'insert into TblMahmoud (txtSmsText) values (?) ON DUPLICATE KEY UPDATE txtSmsText=txtSmsText';
    // String sql = 'insert into TblMahmoud (txtSmsText) values (?)';
    final List<String> mylist = [
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry',
    ];

    await db.then((conn) async {
      for (var value in mylist) {
        await conn
            .query(
              sql,
              [value.toString()],
            )
            .then((results) {})
            .onError((error, stackTrace) {
              log("error $error");

              return null;
            });
      }

      conn.close();
      showToast(
        'This is normal toast with animation',
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.center,
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear,
      );
    });
    isloadingSetData(false);
  }
}
