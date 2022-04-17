// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../control/sms_controller.dart';

class DatabaseVew extends StatelessWidget {
  String? title;

  SmSController controller = Get.find();
  DatabaseVew({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(title!),
        ),
        body: controller.switchVlaue.value == true
            ? const Center(
                child: Text(
                  'Offline in The Database',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )
            : showFutureDBData());
  }

  showFutureDBData() {
    return FutureBuilder<List<String>>(
      future: controller.getmySQLData(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        return ListView.builder(
          itemCount: snapshot.data!.reversed.length,
          itemBuilder: (context, index) {
            final user = snapshot.data![index];
            return Card(
              child: ListTile(
                title: Text(user),
              ),
            );
          },
        );
      },
    );
  }
}
