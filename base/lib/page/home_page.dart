import 'package:flutter/material.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const Center(
            child: Text("HomePage"),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {
                appRouteDelegate.push(
                    name: '/details',
                    arguments:
                        'https://t7.baidu.com/it/u=801209673,1770377204&fm=193&f=GIF');
              },
              child: Text("跳转details"))
        ],
      ),
    ));
  }
}
