//
//  ViewController.m
//  HybirdDemo
//
//  Created by huaxing huang on 2021/7/11.
//

#import "ViewController.h"
#import "AppDelegate.h"
@import Flutter;

@interface ViewController ()

@property (nonatomic, strong) FlutterMethodChannel *messageChannel;
@property (nonatomic, strong) UILabel *resultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton new];
    button.backgroundColor = UIColor.blueColor;
    button.frame = CGRectMake(80, 210, 160, 40);
    [button addTarget:self
               action:@selector(buttonClicked)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"OC 调用 Flutter" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, 50)];
    self.resultLabel.font = [UIFont systemFontOfSize:14.0f];
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.resultLabel];
}

- (void)buttonClicked {
    
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
    }];
}

@end
