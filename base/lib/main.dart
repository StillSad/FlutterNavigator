import 'package:flutter/material.dart';
import 'package:base/route/app_route_delegate.dart';

void main() {
  runApp( MyApp());
}

AppRouteDelegate appRouteDelegate = AppRouteDelegate();

class MyApp extends StatelessWidget {

   MyApp({Key? key}) : super(key: key) {
     appRouteDelegate.push(name: '/splash');
   }

  @override
  Widget build(BuildContext context) {
    var widget = Router(
      routerDelegate: appRouteDelegate,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: widget,
    );
  }
}
