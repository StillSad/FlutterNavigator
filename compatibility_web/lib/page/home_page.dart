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
                appRouteDelegate.push(name: '/details', arguments: {
                  'imgUrl':
                      'https://storage.googleapis.com/cms-storage-bucket/images/featured-stories_Nubank-v2.width-680.png'
                });
              },
              child: Text("跳转details"))
        ],
      ),
    ));
  }
}
