import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sms_app/control/sms_controller.dart';
import 'package:flutter_sms_app/view/database_view.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  SmSController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => DatabaseVew(
                            title: 'Database',
                          ));
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
                  Obx(() {
                    return Row(children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Insert Database',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
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
                              activeColor: Colors.white,
                              hoverColor: Colors.white,
                              value: controller.switchVlaue.value,
                              onChanged: (newValue) {
                                controller.toggle();
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
      ),
    );
  }
}
