import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // 非使用Flutter_Boost与原生 进行交互时，需要加上
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter/cupertino.dart';
import './home_page.dart';

class CustomFlutterBinding extends WidgetsFlutterBinding with BoostFlutterBinding {

}

void main() {
  //在runApp之前确保BoostFlutterBinding初始化
  CustomFlutterBinding();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ///路由表
  static Map<String, FlutterBoostRouteFactory> routerMap = {
    'homePage': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) {
            return HomePage();
          });
    },
    // 'simplePage': (settings, uniqueId) {
    //   return PageRouteBuilder<dynamic>(
    //       settings: settings,
    //       pageBuilder: (_, __, ___) => SimplePage(
    //         data: settings.arguments,
    //       ));
    // },
  };

  Route<dynamic> routeFactory(RouteSettings settings, String uniqueId) {
    FlutterBoostRouteFactory func = routerMap[settings.name];
    if (func == null) {
      return null;
    }
    return func(settings, uniqueId);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(routeFactory);
  }
}

/* 没有使用Flutter_Boost与原生 进行交互
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   // This is the theme of your application.
      //   //
      //   // Try running your application with "flutter run". You'll see the
      //   // application has a blue toolbar. Then, without quitting the app, try
      //   // changing the primarySwatch below to Colors.green and then invoke
      //   // "hot reload" (press "r" in the console where you ran "flutter run",
      //   // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
      //   // counter didn't reset back to zero; the application is not restarted.
      //   primarySwatch: Colors.blue,
      // ),
      home: _HomePage()
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<_HomePage> {
  String title = "Flutter to Native";
  Color backgroundColor = Colors.red;
  // 创建 MethodChannel 这里的标志跟 ios 中设置要一致
  static const MethodChannel methodChannel = const MethodChannel('com.pages.your/native_get');
  // Flutter 调用原生
  _iOSPushToVC() {
    methodChannel.invokeMethod('FlutterToNative', ["Flutter 调用原生参数 1", "Flutter 调用原生参数 2"]);
  }

  @override
  void initState() {
    super.initState();
    // 设置原生调用 Flutter 回调,获取到方法名和参数
    methodChannel.setMethodCallHandler((MethodCall call){
      if (call.method == "NativeToFlutter") {
        setState(() {
          List<dynamic> arguments = call.arguments;
          String str = "";
          for (dynamic string in arguments) {
            str = str + " " + string;
          }
          title = str;
          backgroundColor = Colors.orange;
        });
      }
      return Future<dynamic>.value();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Text(title),
          onTap: (){
            _iOSPushToVC();
          },
        ),
      ),
    );
  }
} */
