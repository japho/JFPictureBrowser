//
//  JFProgressHUD.h
//  JFHUD
//
//  Created by Japho on 16/1/18.
//  Copyright © 2016年 Japho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface JFProgressHUD : NSObject

/**
 *  显示等待视图
 *
 *  @param view 显示到所需父视图
 *  @param text 显示text
 *
 *  @return hud实例对象
 */
+ (MBProgressHUD *)showWaitingHUDInView:(UIView *)view text:(NSString *)text;

/**
 *  根据hud实例对象隐藏等待视图
 *
 *  @param hud   hud实例对象
 *  @param delay 延迟秒数
 */
+ (void)hideWithHUD:(MBProgressHUD *)hud afterDelay:(CGFloat)delay;

/**
 *  显示提示信息视图
 *
 *  @param view       显示到所需父视图
 *  @param text       titleText
 *  @param detailText detailText
 *  @param delay      隐藏延迟秒数
 */
+ (void)showTextHUDInView:(UIView *)view text:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(CGFloat)delay;

@end
