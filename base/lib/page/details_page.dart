import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  String imageUrl;

  DetailsPage(this.imageUrl, {Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Container(
        child: SafeArea(
          child: Container(child: Image.network(widget.imageUrl),),
        ),
      )
    );
  }
}
