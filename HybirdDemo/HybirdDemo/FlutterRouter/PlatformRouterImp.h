//
//  PlatformRouterImp.h
//  HybirdDemo
//
//  Created by huanghuaxing on 2021/7/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FlutterBoost.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformRouterImp : NSObject<FLBPlatform>

#pragma mark - Property

@property (nonatomic, weak) UINavigationController *navigationController;


#pragma mark - Method

+ (instancetype)shareRouter;

@end

NS_ASSUME_NONNULL_END
