//
//  AppDelegate.m
//  HybirdDemo
//
//  Created by huaxing huang on 2021/7/11.
//

#import "AppDelegate.h"
//#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
#import "BoostDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 兼容iOS13以前的项目AppDelegate和SceneDelegate类方法里设置
    if (@available(iOS 13.0, *)) {
        
    } else {
    
        // 默认方法
        BoostDelegate *boostDelegate = [[BoostDelegate alloc ] init];
        UIApplication *application = [UIApplication sharedApplication];
        [[FlutterBoost instance] setup:application delegate:boostDelegate callback:^(FlutterEngine *engine) {

        }];
        
        // 原生页面
        ViewController *vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"hybrid" image:nil tag:0];
       
        // flutter页面
        FBFlutterViewContainer *fvc = FBFlutterViewContainer.new;
        [fvc setName:@"mainPage" uniqueId:nil params:@{} opaque:YES];
        fvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"flutter_tab" image:nil tag:1];


        UITabBarController *tabVC = [[UITabBarController alloc] init];
        tabVC.viewControllers = @[vc, fvc];

        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tabVC];
        
        boostDelegate.navigationController = nvc;
        
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.rootViewController = nvc;
        [self.window makeKeyAndVisible];
        
    }
    
    /* 没有使用Flutter_Boost与原生 进行交互
    self.flutterEngine = [[FlutterEngine alloc] initWithName:@"my flutter engine"];
    [self.flutterEngine run];
    [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
     */
    
    return YES;
}

/**
 切记：当适配了SceneDelegate后，iOS13及以上设备不会再调用AppDelegate以下状态的方法，iOS13以前的设备会
 继续调用。比如：applicationWillResignActive，iOS13及以上设备会调用SceneDelegate的sceneWillResignActive。
 */

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)) {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

@end
