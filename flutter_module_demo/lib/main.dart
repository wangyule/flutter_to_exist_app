import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart'; // 非使用Flutter_Boost与原生 进行交互时，需要加上
import 'package:flutter_boost/flutter_boost.dart';
import 'pages/home_page.dart';
import 'pages/main_page.dart';
import 'pages/simple_page.dart';
import 'pages/lifecycle_test_page.dart';
import 'pages/replacement_page.dart';
import 'pages/dialog_page.dart';

///创建一个自定义的Binding，继承和with的关系如下，里面什么都不用写
class CustomFlutterBinding extends WidgetsFlutterBinding with BoostFlutterBinding {}

void main() {
  //添加全局生命周期监听类
  PageVisibilityBinding.instance.addGlobalObserver(AppLifecycleObserver());

  /**
   * 在runApp之前确保BoostFlutterBinding初始化
   * 这里的CustomFlutterBinding调用务必不可缺少，用于控制Boost状态的resume和pause
   */
  CustomFlutterBinding();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /**
   由于很多同学说没有跳转动画，这里是因为之前exmaple里面用的是 [PageRouteBuilder]，
   其实这里是可以自定义的，和Boost没太多关系，比如我想用类似iOS平台的动画，
   那么只需要像下面这样写成 [CupertinoPageRoute] 即可
   (这里全写成[MaterialPageRoute]也行，这里只不过用[CupertinoPageRoute]举例子)

   注意，如果需要push的时候，两个页面都需要动的话，
  （就是像iOS native那样，在push的时候，前面一个页面也会向左推一段距离）
   那么前后两个页面都必须是遵循CupertinoRouteTransitionMixin的路由
   简单来说，就两个页面都是CupertinoPageRoute就好
   如果用MaterialPageRoute的话同理
    */
  ///路由表(用于原生通过flutter_boost打开以下页面)
   Map<String, FlutterBoostRouteFactory> routerMap = {
    // 首页
    'homePage': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) {
            return HomePage();
          });
    },

     // 'mainPage': (RouteSettings settings, String uniqueId) {
     //   return CupertinoPageRoute(
     //       settings: settings,
     //       builder: (_) {
     //         Map<String, Object> map = settings.arguments as Map<String, Object> ;
     //         String data = map['data'] as String;
     //         return MainPage(
     //           data: data,
     //         );
     //       });
     // },

    'mainPage': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) {
            Map<String, Object> map = settings.arguments as Map<String, Object>;
            String data = map['data'] as String;
            return MainPage(
              data: data,
            );
          });
    },

    'simplePage': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (_, __, ___) {
            Map<String, Object> map = settings.arguments as Map<String, Object>;
            String data = map['data'] as String;
            return SimplePage(data: data);
          });
    },

    ///生命周期例子页面
    'lifecyclePage': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => LifecycleTestPage());
    },
    'replacementPage': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(
          settings: settings, pageBuilder: (_, __, ___) => ReplacementPage());
    },

    ///透明弹窗页面
    'dialogPage': (settings, uniqueId) {
      return PageRouteBuilder<dynamic>(

        ///透明弹窗页面这个需要是false
          opaque: false,

          ///背景蒙版颜色
          barrierColor: Colors.black12,
          settings: settings,
          pageBuilder: (_, __, ___) => DialogPage());
    },
  };

  Route<dynamic>? routeFactory(RouteSettings settings, String? uniqueId) {
    FlutterBoostRouteFactory? func = routerMap[settings.name];
    if (func == null) {
      return null;
    }
    return func(settings, uniqueId);
  }

  Widget appBuilder(Widget home) {
    return MaterialApp(home: home, debugShowCheckedModeBanner: false);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(
      routeFactory,
      appBuilder: appBuilder,
    );
  }
}

/* 没有使用Flutter_Boost第三方库，而是自己实现Flutter与原生 进行交互
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
