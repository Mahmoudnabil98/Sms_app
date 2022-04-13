import 'dart:developer';

import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';

class SmSController extends GetxController {
  SmsQuery query = SmsQuery();
  var isLoading = false.obs;
  var messages = <SmsMessage>[].obs;
  SmsMessage? smsMessage;
  var switchVlaue = false.obs;

  @override
  void onReady() {
    getInboxSms();
    // setmySQLData();
    super.onReady();
  }

  void toggle() {
    switchVlaue.value = !switchVlaue.value;
  }

  void getInboxSms() async {
    isLoading.value = true;
    final status = await Permission.sms.status;
    if (!status.isGranted) {
      Permission.sms.request();
    } else if (status.isGranted) {
      messages.value = await query.getAllSms;
    }
    isLoading.value = false;
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

  Future<void> setmySQLData() async {
    var db = getConnection();
    String sql = 'insert into TblMahmoud (txtSmsText) values (?)';
    final List<String> mylist = [
      'test1',
      'test2',
      'test3',
    ];

    await db.then((conn) async {
      for (var value in mylist) {
        await conn
            .query(sql, [value.toString()])
            .then((results) {})
            .onError((error, stackTrace) {
              log("error $error");

              return null;
            });
      }

      conn.close();
    });
  }
}
