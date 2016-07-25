//
//  JFPictureBrowserView.h
//  JFPictureBrowser
//
//  Created by Japho on 16/3/14.
//  Copyright © 2016年 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JFPictureBrowserViewDelegate <NSObject>

@end

@interface JFPictureBrowserView : UIView

/** 图片地址数组 */
@property (nonatomic, strong) NSArray *imageURLStringGroup;

/** 图片名称数组 */
@property (nonatomic, strong) NSArray *imageNamesGroup;

/** 图片数组(UIImage对象) */
@property (nonatomic, strong) NSArray *imageGroup;

/** 图片地址数组 */
@property (nonatomic, assign) NSInteger startIndex;

@property (nonatomic, assign) id<JFPictureBrowserViewDelegate> delegate;

/**
 *  网络图片初始化方式
 *
 *  @param frame
 *  @param delegate
 *  @param imageURLStringGroup 网络地址数组
 *
 *  @return
 */
+ (instancetype)pictureBrowsweViewWithFrame:(CGRect)frame delegate:(id<JFPictureBrowserViewDelegate>)delegate imageURLStringGroup:(NSArray *)imageURLStringGroup;

/**
 *  本地图片初始化方式
 *
 *  @param frame
 *  @param delegate
 *  @param imageNamesGroup 本地图片数组
 *
 *  @return 
 */
+ (instancetype)pictureBrowsweViewWithFrame:(CGRect)frame delegate:(id<JFPictureBrowserViewDelegate>)delegate imageNamesGroup:(NSArray *)imageNamesGroup;

/**
 *  image对象初始化方式
 *
 *  @param frame
 *  @param delegate
 *  @param imageGroup image对象
 *
 *  @return 
 */
+ (instancetype)pictureBrowsweViewWithFrame:(CGRect)frame delegate:(id<JFPictureBrowserViewDelegate>)delegate imageGroup:(NSArray *)imageGroup;

/**
 *  清除图片缓存
 */
+ (void)clearImagesCache;

/**
 *  显示在父视图
 *
 *  @param view 父视图
 */
- (void)showInView:(UIView *)view;

@end