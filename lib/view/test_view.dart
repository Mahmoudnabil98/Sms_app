import 'package:flutter/material.dart';

class TestView extends StatefulWidget {
  TestView({Key? key}) : super(key: key);

  @override
  State<TestView> createState() => _TestViewState();
}

Stream<int> streamNumber() async* {
  await Future.delayed(const Duration(seconds: 1), () {});
  for (int i = 0; i < 50; i++) {
    await Future.delayed(const Duration(seconds: 1), () {});
    yield i;
  }
}

class _TestViewState extends State<TestView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<int>(
            stream: streamNumber(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData) {
                  return Center(
                    child: snapshot.data! < 10
                        ? Text(snapshot.data.toString(),
                            style: const TextStyle(
                                color: Colors.teal, fontSize: 36))
                        : Container(
                            height: 100,
                            width: snapshot.data == 15 ? 300 : 100,
                            color: Colors.redAccent,
                          ),
                  );
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            }));
  }
}
