import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Top Lakes'),
        ),
        body: ListView(
          children: <Widget>[
            Image.asset(
              'images/lake.jpg',
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,
            ),
          ],
        ));
  }
}