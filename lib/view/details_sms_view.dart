import 'package:flutter/material.dart';

class DetailsSmsView extends StatelessWidget {
  String? text;
  DetailsSmsView({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Sms'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            alignment: Alignment.topLeft,
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: 200,
                child: Text(text.toString()),
              ),
            ),
          )
        ],
      ),
    );
  }
}
