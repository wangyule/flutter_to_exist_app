import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';

class HomePage extends StatefulWidget{
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  @override

  ///声明一个用来存回调的对象
  // VoidCallback removeListener;
  ///添加事件响应者,监听native发往flutter端的事件
  VoidCallback removeListener = BoostChannel.instance.addEventListener("yourEventKey", (key, arguments) {
    ///deal with your event here
    print('监听到native发往flutter端的事件, ${arguments}');
    return Future<dynamic>(() => null);
  });

  @override
  void dispose() {
    removeListener();
}

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Lakes'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Image.asset(
                'images/lake.jpg',
                width: 600.0,
                height: 240.0,
                fit: BoxFit.cover,
              ),
            ),

            Text('hello world'),

            IconButton(
              icon: const Icon(Icons.cancel_schedule_send_rounded),
              // 如果有抽屉的话的就打开
              onPressed: () {
                // BoostNavigator.instance.pop('Hello, I am from PushWidget.'); // flutter_boost关闭页面
                // Navigator.of(context).pop('Hello, I am from PushWidget.'); // flutter系统自带关闭页面
                // 发送消息给native
                BoostChannel.instance.sendEventToNative("eventToNative",{"key1":"value1"});
                print('sendEventToNative');
              },
              // 显示描述信息
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ],
        ),
      ),
    );
  }
}