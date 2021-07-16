//
//  ViewController.m
//  HybirdDemo
//
//  Created by huaxing huang on 2021/7/11.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <flutter_boost/FlutterBoost.h>
//#import "FlutterBoostPlugin.h"
//@import Flutter;

@interface ViewController ()

//@property (nonatomic, strong) FlutterMethodChannel *messageChannel;
@property (nonatomic, strong) UILabel *resultLabel;

// 同样声明一个对象用来存删除的函数
@property (nonatomic, copy) FBVoidCallback removeListener;

@end

@implementation ViewController

- (void)dealloc {
    if (self.removeListener) {
        self.removeListener();
        self.removeListener = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton new];
    button.backgroundColor = UIColor.blueColor;
    button.frame = CGRectMake(80, 210, 160, 40);
    [button addTarget:self
               action:@selector(buttonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"OC push Flutter" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, 50)];
    self.resultLabel.font = [UIFont systemFontOfSize:14.0f];
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.resultLabel];
    
    
    UIButton *button2 = [UIButton new];
    button2.backgroundColor = UIColor.blueColor;
    button2.frame = CGRectMake(80, 280, 160, 40);
    [button2 addTarget:self
               action:@selector(buttonClicked2)
     forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"OC present Flutter" forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    
    /**
     自定义事件传递API
     这个部分相当于让开发者省略了手动搭桥的功能，通过事件标识key和参数map即可完成事件传递
     
     这里注册事件监听，监听flutter发送到iOS的事件
     */
    __weak typeof(self) weakSelf = self;
    self.removeListener = [[FlutterBoost instance] addEventListener:^(NSString *name, NSDictionary *arguments) {
        //注意，如果这里self持有removeListener，而这个闭包中又有self的话，要用weak self
        //否则就有self->removeListener->self 循环引用

        //在这里处理你的事件
        NSLog(@"name:%@, arguments:%@", name, arguments);
        
    } forName:@""];
    
    UIButton *button3 = [UIButton new];
    button3.backgroundColor = UIColor.blueColor;
    button3.frame = CGRectMake(80, 350, 160, 40);
    [button3 addTarget:self
               action:@selector(buttonClicked3)
     forControlEvents:UIControlEventTouchUpInside];
    [button3 setTitle:@"native send event to Flutter" forState:UIControlStateNormal];
    [self.view addSubview:button3];
}

- (void)buttonClicked {
    
    FlutterBoostRouteOptions *options = [[FlutterBoostRouteOptions alloc] init];
    options.pageName = @"homePage";
    options.arguments = @{@"animated":@(YES)};
    options.completion = ^(BOOL completion) {
        // 打开flutter页面后，会回调
        
    };
    [[FlutterBoost instance] open:options];
    
    /** 没有使用Flutter_Boost与原生 进行交互
    // 获取全局的 flutterEngine,防止跳转的时候卡顿
    FlutterEngine *flutterEngine = ((AppDelegate *)UIApplication.sharedApplication.delegate).flutterEngine;
    // 跳转的界面控制器
    FlutterViewController *flutterController = [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    // 设置标记,需要跟 dart 中的 main.dart 一致
    NSString *channelName = @"com.pages.your/native_get";
    // 创建 FlutterMethodChannel
    _messageChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:flutterController.binaryMessenger];
    // 设置当前 FlutterMethodChannel 的方法名和需要传递过去的参数
    [_messageChannel invokeMethod:@"NativeToFlutter" arguments:@[@"原生调用Flutter参数1", @"原生调用Flutter参数2"]];
    // 跳转界面
    [self.navigationController pushViewController:flutterController animated:YES];
    // Flutter 回调
    __weak typeof(self) weakSelf = self;
    [_messageChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        [flutterController.navigationController popViewControllerAnimated:YES];
        NSArray *array = (NSArray *)call.arguments;
        NSMutableString *mutableString = [NSMutableString string];
        for (NSString *string in array) {
            [mutableString appendFormat:@"%@ ", string];
        }
        weakSelf.resultLabel.text = mutableString;
    }]; */
}

- (void)buttonClicked2 {
    FlutterBoostRouteOptions *options = [[FlutterBoostRouteOptions alloc] init];
    options.pageName = @"homePage";
    options.arguments = @{@"present":@(YES)};
    options.opaque = NO;
    options.completion = ^(BOOL completion) {

    };

    [[FlutterBoost instance] open:options];
}

- (void)buttonClicked3 {
    // swift
//    FlutterBoost.instance().sendEventToFlutter(with: "event", arguments: ["data":"event from native"])
    [[FlutterBoost instance] sendEventToFlutterWith:@"event" arguments:@{@"data":@"event from native"}];
}

@end
