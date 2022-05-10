import 'package:compatibility_web/route/app_route_information_parser.dart';
import 'package:flutter/material.dart';
import 'package:compatibility_web/route/app_route_delegate.dart';


void main() {
  runApp(MyApp());
}

AppRouteDelegate appRouteDelegate = AppRouteDelegate();

class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key) {
    appRouteDelegate.push(name: '/splash');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routeInformationParser: const AppRouteInformationParser(),
        routerDelegate: appRouteDelegate);

    // var widget = Router(
    //   routerDelegate: appRouteDelegate,
    //   routeInformationParser: const AppRouteInformationParser(),
    //   backButtonDispatcher: RootBackButtonDispatcher(),
    // );
    //
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: widget,
    // );
  }
}
