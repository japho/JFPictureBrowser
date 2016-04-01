//
//  JFProgressHUD.m
//  JFHUD
//
//  Created by Japho on 16/1/18.
//  Copyright © 2016年 Japho. All rights reserved.
//

#import "JFProgressHUD.h"
#import "MBProgressHUD.h"

@implementation JFProgressHUD

+ (MBProgressHUD *)showWaitingHUDInView:(UIView *)view text:(NSString *)text
{
    UIImage *image = [UIImage imageNamed:@"JFProgressHUD_pic"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.image = image;
    
    //添加动画
    CABasicAnimation *monkeyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    monkeyAnimation.toValue = [NSNumber numberWithFloat:2.0 *M_PI];
    monkeyAnimation.duration = 1.0f;
    monkeyAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    monkeyAnimation.cumulative = NO;
    monkeyAnimation.removedOnCompletion = NO; //No Remove
    
    monkeyAnimation.repeatCount = FLT_MAX;
    [imageView.layer addAnimation:monkeyAnimation forKey:@"AnimatedKey"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    //设置text
    hud.labelText = text;
    
    // 设置自定义视图
    hud.customView = imageView;
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    //设置hud的color
    hud.color = [UIColor colorWithWhite:0 alpha:0.4];
    
    return hud;
}

+ (void)hideWithHUD:(MBProgressHUD *)hud afterDelay:(CGFloat)delay
{
    [hud hide:YES afterDelay:delay];
}

+ (void)showTextHUDInView:(UIView *)view text:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(CGFloat)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setMode:MBProgressHUDModeText];
    [hud setLabelText:text];
    [hud setDetailsLabelText:detailText];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setColor:[UIColor colorWithWhite:0 alpha:0.4]];
    [hud hide:YES afterDelay:delay];
}

@end
