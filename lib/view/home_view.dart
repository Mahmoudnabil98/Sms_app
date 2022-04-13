import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sms_app/control/sms_controller.dart';
import 'package:flutter_sms_app/view/database_view.dart';
import 'package:flutter_sms_app/widget/drawer.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  SmSController controller = Get.put(SmSController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text('Inbox Sms'),
        actions: [
          Obx(() {
            return Row(
              children: [
                Text(
                  controller.switchVlaue.value == false ? 'disable' : 'enabile',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Switch(
                    activeColor: Colors.white,
                    hoverColor: Colors.white,
                    value: controller.switchVlaue.value,
                    onChanged: (newValue) {
                      controller.toggle();
                    }),
              ],
            );
          }),
          TextButton(
              onPressed: () {
                Get.to(() => DatabaseVew(
                      title: 'Database',
                    ));
              },
              child: const Text(
                'Database',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )),
          TextButton(
              onPressed: () => exit(0),
              child: const Text(
                'Exit',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const LinearProgressIndicator())
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
                                  title: Text(controller.messages[index].address
                                      .toString()),
                                  content: Text(controller.messages[index].body
                                      .toString()),
                                ));
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.markunread,
                          color: Colors.pink,
                        ),
                        title:
                            Text(controller.messages[index].address.toString()),
                        subtitle: Text(
                          controller.messages[index].isRead.toString() == 'true'
                              ? 'Read Message'
                              : 'Unread Message',
                          maxLines: 2,
                          style: const TextStyle(),
                        ),
                      ),
                    ),
                  );
                });
      }),
    );
  }
}
