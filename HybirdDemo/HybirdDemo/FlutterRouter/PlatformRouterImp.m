//
//  PlatformRouterImp.m
//  HybirdDemo
//
//  Created by huanghuaxing on 2021/7/12.
//

#import "PlatformRouterImp.h"

static PlatformRouterImp *_router;

@interface PlatformRouterImp ()

@end

@implementation PlatformRouterImp

#pragma mark - Lifecycle

+ (instancetype)shareRouter {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _router = [[PlatformRouterImp alloc] init];
    });
    
    return _router;
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}


#pragma mark - Custom Accessors (Setter 方法)


#pragma mark - Public


#pragma mark - Private


#pragma mark - Protocol

/**
* 基于Native平台实现页面打开，Dart层的页面打开能力依赖于这个函数实现；Native或者Dart侧不建议直接使用这个函数。应直接使用FlutterBoost封装的函数
*
* @param url 打开的页面资源定位符
* @param urlParams 传人页面的参数; 若有特殊逻辑，可以通过这个参数设置回调的id
* @param exts 额外参数
* @param completion 打开页面的即时回调，页面一旦打开即回调
*/
- (void)open:(NSString *)url
  urlParams:(NSDictionary *)urlParams
        exts:(NSDictionary *)exts
  completion:(void (^)(BOOL finished))completion {
    
    FLBFlutterViewContainer *controller = [FLBFlutterViewContainer new];
    // 这句代码千万不能省略
    [controller setName:url params:urlParams];
    if (self.navigationController) {
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (completion) {
        completion(YES);
    }
}


#pragma mark - 懒加载

@end
