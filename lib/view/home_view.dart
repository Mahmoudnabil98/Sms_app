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
      body: Obx(() {
        return controller.isLoading.value == true
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const LinearProgressIndicator())
            : controller.permissionStatus.value == PermissionStatus.granted
                ? GetBuilder<SmSController>(
                    init: controller,
                    initState: (state) {
                      controller.getInboxSms();
                    },
                    builder: (context) {
                      return ListView.separated(
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
                                  title: GestureDetector(
                                    onTap: () {
                                      log(" dadat $index ${controller.messages[index]}");
                                    },
                                    child: Text(controller
                                        .messages[index].address
                                        .toString()),
                                  ),
                                  subtitle: Text(
                                    controller.mylist.contains(
                                                "Address: ${controller.messages[index].address.toString()} | Body: ${controller.messages[index].body.toString()} | DateTime: ${controller.messages[index].dateSent.toString().substring(0, 16)}") ==
                                            true
                                        ? 'Read Message'
                                        : 'Unread Message',
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: controller.mylist.contains(
                                                    "Address: ${controller.messages[index].address.toString()} | Body: ${controller.messages[index].body.toString()} | DateTime: ${controller.messages[index].dateSent.toString().substring(0, 16)}") ==
                                                true
                                            ? Colors.green
                                            : Colors.redAccent),
                                  ),
                                  trailing: Text(controller
                                      .messages[index].dateSent
                                      .toString()
                                      .substring(0, 16)),
                                ),
                              ),
                            );
                          });
                    })
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Refresh data from SMS box to verify access",
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(5)),
                          height: 40,
                          width: 100,
                          child: TextButton(
                              onPressed: () async {
                                controller.checkPermission();
                              },
                              child: const Text(
                                "Refresh",
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  );
      }),
    );
  }
}
