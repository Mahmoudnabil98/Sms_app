import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sms_app/control/sms_controller.dart';
import 'package:flutter_sms_app/view/database_view.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  SmSController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: 'Setting',
      backgroundColor: Colors.white,
      elevation: 10,
      child: Column(
        children: [
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.blueAccent),
          ),
          const SizedBox(
            height: 5,
          ),
          // ignore: unrelated_type_equality_checks
          Obx(() => controller.isloadingSetData == true
              ? LinearProgressIndicator()
              : SizedBox()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(
                        () => DatabaseVew(
                              title: 'Database',
                            ),
                        transition: Transition.zoom);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      'Database',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.shade500,
                ),
                GestureDetector(
                  onTap: () {
                    if (controller.switchVlaue.value == true) {
                      log("${controller.switchVlaue.value}");
                      showToast(
                        'Offline in the database',
                        context: context,
                        animation: StyledToastAnimation.scale,
                        reverseAnimation: StyledToastAnimation.fade,
                        position: StyledToastPosition.center,
                        animDuration: const Duration(seconds: 1),
                        duration: const Duration(seconds: 4),
                        curve: Curves.elasticOut,
                        backgroundColor: Colors.redAccent,
                        reverseCurve: Curves.linear,
                      );
                    } else {
                      controller.setmySQLData(context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      'Insert Database',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.shade500,
                ),
                Obx(() {
                  return Row(children: [
                    const Expanded(
                      flex: 4,
                      child: Text(
                        'Disconnecting the database',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          controller.switchVlaue.value == false
                              ? 'disable'
                              : 'enabile',
                          style: TextStyle(
                              color: controller.switchVlaue.value == false
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Switch(
                            value: controller.switchVlaue.value,
                            onChanged: (newValue) {
                              controller.connectDatabase();
                            }),
                      ],
                    )
                  ]);
                }),
                Divider(
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () => exit(0),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.grey.shade500,
                      )),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    'Exit App',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
