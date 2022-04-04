import 'package:get/get.dart';
import 'package:sms_advanced/sms_advanced.dart';

class SmSController extends GetxController {
  SmsQuery query = SmsQuery();
  var isLoading = false.obs;

  var messages = <SmsMessage>[].obs;
  //var vas = <SmsModel>[].obs;
  SmsMessage? smsMessage;
  //SmsModel? smsModel;

  List<Map<String, Object?>> maps = [];

  // Map<String, Object?> get toMap {
  //   Map<String, Object?> data = {};
  //   if (smsMessage!.address != null) {
  //     data["address"] = smsMessage!.address;
  //   }
  //   if (smsMessage!.body != null) {
  //     data["body"] = smsMessage!.body;
  //   }
  //   if (smsMessage!.id != null) {
  //     data["id"] = smsMessage!.id;
  //   }
  //   if (smsMessage!.threadId != null) {
  //     data["thread_id"] = smsMessage!.threadId;
  //   }
  //   if (smsMessage!.isRead != null) {
  //     data["read"] = smsMessage!.isRead;
  //   }
  //   if (smsMessage!.date != null) {
  //     data["date"] = smsMessage!.date!.millisecondsSinceEpoch;
  //   }
  //   if (smsMessage!.dateSent != null) {
  //     data["dateSent"] = smsMessage!.dateSent!.millisecondsSinceEpoch;
  //   }
  //   return data;
  // }

  @override
  void onReady() {
    getInboxSms();
    super.onReady();
  }

  void getInboxSms() async {
    isLoading.value = true;
    messages.value = await query.getAllSms;
    // messages.value.forEach((element) {
    //   smsMessage = element;
    //   maps.add(toMap);
    // });
    // //saveData(maps);
    isLoading.value = false;
  }

  // void saveData(List<Map<String, Object?>> data) async {
  //   data.forEach((element) {
  //     Map map = element;
  //     smsModel = SmsModel.fomJson(map);

  //     // log('smsModel ${smsModel}');
  //   });
  //   DataBaseHelper.dbHelper.insertSms(smsModel);
  //   log('smsModel ${smsModel!.date.toString()}');
  // }

}
