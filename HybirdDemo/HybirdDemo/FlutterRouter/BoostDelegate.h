//
//  BoostDelegate.h
//  HybirdDemo
//
//  Created by huanghuaxing on 2021/7/14.
//

#import <Foundation/Foundation.h>
#import <flutter_boost/FlutterBoost.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoostDelegate : NSObject<FlutterBoostDelegate>

@property (nonatomic,strong) UINavigationController *navigationController;

@end

NS_ASSUME_NONNULL_END
