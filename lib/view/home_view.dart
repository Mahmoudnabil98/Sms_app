import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sms_app/control/sms_controller.dart';
import 'package:flutter_sms_app/view/Details_Sms_View.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  SmSController controller = Get.put(SmSController());

  @override
  Widget build(BuildContext context) {
    log(' controller ${controller.messages.length}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox Sms'),
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailsSmsView(
                                text: controller.messages[index].body
                                    .toString())));
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
