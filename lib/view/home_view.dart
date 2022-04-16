import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_sms_app/control/sms_controller.dart';
import 'package:flutter_sms_app/widget/drawer.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  SmSController controller = Get.put(SmSController());
  HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Inbox Sms'),
      ),
      body: GetBuilder<SmSController>(
          init: SmSController(),
          initState: (state) {
            controller.getInboxSms();
          },
          builder: (control) {
            return controller.isLoading.value == true
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: const LinearProgressIndicator())
                : controller.permissionStatus.isDenied == true
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "You must grant access to a message box",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await Permission.sms.request().then((value) {
                                    controller.getInboxSms();
                                  }).catchError((onError) {
                                    log("Error");
                                  });
                                },
                                child: const Text(
                                  "refrech",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              color: Colors.black,
                            ),
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text(controller
                                              .messages[index].address
                                              .toString()),
                                          content: Text(controller
                                              .messages[index].body
                                              .toString()),
                                        ));
                              },
                              child: ListTile(
                                leading: const Icon(
                                  Icons.markunread,
                                  color: Colors.blueAccent,
                                ),
                                title: Text(controller.messages[index].address
                                    .toString()),
                                subtitle: Text(
                                  controller.isReadMessage(controller
                                              .messages[index].isRead
                                              .toString()) ==
                                          true
                                      ? 'Read Message'
                                      : 'Unread Message',
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: controller.isReadMessage(controller
                                                .messages[index].isRead
                                                .toString()) ==
                                            false
                                        ? Colors.redAccent
                                        : Colors.green,
                                  ),
                                ),
                                trailing: Text(controller
                                    .messages[index].dateSent
                                    .toString()
                                    .substring(0, 16)),
                              ),
                            ),
                          );
                        });
          }),
    );
  }
}
