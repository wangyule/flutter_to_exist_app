//
//  BoostDelegate.m
//  HybirdDemo
//
//  Created by huanghuaxing on 2021/7/14.
//

#import "BoostDelegate.h"

typedef void(^OnPageFinishedBlock)(NSDictionary *);

@interface BoostDelegate()

/// 用于传递数据
@property (nonatomic,strong) NSMutableDictionary *resultDic;

@end

@implementation BoostDelegate

/// push原生页面
/// @param pageName 页面类名
/// @param arguments 参数
- (void)pushNativeRoute:(NSString *)pageName arguments:(NSDictionary *)arguments {
    BOOL animated = [arguments[@"animated"] boolValue];
    BOOL present= [arguments[@"present"] boolValue];
    UIViewController *vc = [[NSClassFromString(pageName) alloc] initWithNibName:nil bundle:nil];
    if (present) {
        [self.navigationController presentViewController:vc animated:animated completion:^{
        }];
    } else {
        [self.navigationController pushViewController:vc animated:animated];
    }
}

/// push flutter页面
/// @param options 参数
- (void)pushFlutterRoute:(FlutterBoostRouteOptions *)options {
    FBFlutterViewContainer *vc = FBFlutterViewContainer.new;
    [vc setName:options.pageName uniqueId:options.uniqueId params:options.arguments opaque:options.opaque];
    
    // 是否伴随动画
    BOOL animated = [options.arguments[@"animated"] boolValue];
    // 是否是present的方式打开,如果要push的页面是透明的，那么也要以present形式打开
    BOOL present = [options.arguments[@"present"] boolValue] || !options.opaque;
    
    // 对这个页面设置结果
    [self.resultDic setValue:options.onPageFinished forKey:options.pageName];
    
    // 如果是present模式 或者 要不透明模式，那么就需要以present模式打开页面
    if (present) {
        [self.navigationController presentViewController:vc animated:animated completion:^{
            options.completion(YES);
        }];
    } else {
        [self.navigationController pushViewController:vc animated:animated];
        options.completion(YES);
    }
}

- (void)popRoute:(FlutterBoostRouteOptions *)options {
    // 拿到当前vc
    FBFlutterViewContainer *vc = (id)self.navigationController.presentedViewController;
    
    // 如果当前被present的vc是container，那么就执行dismiss逻辑
    if ([vc isKindOfClass:FBFlutterViewContainer.class] && [vc.uniqueIDString isEqual: options.uniqueId]) {
        
        // 这里分为两种情况，由于UIModalPresentationOverFullScreen下，生命周期显示会有问题
        // 所以需要手动调用的场景，从而使下面底部的vc调用viewAppear相关逻辑
        if (vc.modalPresentationStyle == UIModalPresentationOverFullScreen) {
            
            //这里手动beginAppearanceTransition触发页面生命周期
            [self.navigationController.topViewController beginAppearanceTransition:YES animated:NO];
            
            [vc dismissViewControllerAnimated:YES completion:^{
                [self.navigationController.topViewController endAppearanceTransition];
            }];
        } else {
            // 正常场景，直接dismiss
            [vc dismissViewControllerAnimated:YES completion:^{}];
        }
    } else {
        // 否则走pop逻辑
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    // 否则直接执行pop逻辑
    // 这里在pop的时候将参数带出,并且从结果表中移除
    OnPageFinishedBlock finishedBlock = self.resultDic[options.pageName];
    if (finishedBlock) {
        finishedBlock(options.arguments);
        [self.resultDic removeObjectForKey:options.pageName];
    }
}

- (NSMutableDictionary *)resultDic {
    if (!_resultDic) {
        _resultDic = [NSMutableDictionary dictionary];
    }
    
    return _resultDic;
}

@end
