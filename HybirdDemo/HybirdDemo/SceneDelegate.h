//
//  SceneDelegate.h
//  HybirdDemo
//
//  Created by huaxing huang on 2021/7/11.
//

#import <UIKit/UIKit.h>

/**
 切记：当适配了SceneDelegate后，iOS13及以上设备不会再调用AppDelegate以下状态的方法，iOS13以前的设备会
 继续调用。比如：applicationWillResignActive，iOS13及以上设备会调用SceneDelegate的sceneWillResignActive。
 也可以不适配SceneDelegate，方法可参考：
 https://blog.csdn.net/weixin_38735568/article/details/101266408
 */
API_AVAILABLE(ios(13.0))
@interface SceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

