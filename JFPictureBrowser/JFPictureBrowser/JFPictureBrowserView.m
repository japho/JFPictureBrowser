//
//  JFPictureBrowserView.m
//  JFPictureBrowser
//
//  Created by Japho on 16/3/14.
//  Copyright © 2016年 Japho. All rights reserved.
//

#import "JFPictureBrowserView.h"
#import "JFPictureBrowserCell.h"
#import "UIImageView+WebCache.h"
#import "JFProgressHUD.h"

#define kViewWidth      [[UIScreen mainScreen] bounds].size.width
#define kViewHeight     [[UIScreen mainScreen] bounds].size.height
#define kItemMargin     40

@interface JFPictureBrowserView () <UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIScrollView *selectScrollView;
@property (nonatomic, strong) NSArray *imagePathsArray;
@property (nonatomic, assign) BOOL hasAddedHud;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UIImage *currentImage;

@end

@implementation JFPictureBrowserView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addContentView];
    }
    
    return self;
}

#pragma mark - Instant Methods

+ (instancetype)pictureBrowsweViewWithFrame:(CGRect)frame delegate:(id<JFPictureBrowserViewDelegate>)delegate imageGroup:(NSArray *)imageGroup
{
    JFPictureBrowserView *pictureBrowserView = [[self alloc] initWithFrame:frame];
    pictureBrowserView.delegate = delegate;
    pictureBrowserView.imageGroup = imageGroup;
    
    return pictureBrowserView;
}

+ (instancetype)pictureBrowsweViewWithFrame:(CGRect)frame delegate:(id<JFPictureBrowserViewDelegate>)delegate imageNamesGroup:(NSArray *)imageNamesGroup
{
    JFPictureBrowserView *pictureBrowserView = [[self alloc] initWithFrame:frame];
    pictureBrowserView.delegate = delegate;
    pictureBrowserView.imageNamesGroup = imageNamesGroup;
    
    return pictureBrowserView;
}

+ (instancetype)pictureBrowsweViewWithFrame:(CGRect)frame delegate:(id<JFPictureBrowserViewDelegate>)delegate imageURLStringGroup:(NSArray *)imageURLStringGroup
{
    JFPictureBrowserView *pictureBrowserView = [[self alloc] initWithFrame:frame];
    pictureBrowserView.delegate = delegate;
    pictureBrowserView.imageURLStringGroup = imageURLStringGroup;
    
    return pictureBrowserView;
}

+ (void)clearImagesCache
{
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    self.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    } completion:nil];
}

#pragma mark - Customed Methods

- (void)addContentView
{
    [self addSubview:self.collectionView];
    [self addSubview:self.pageLabel];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message;
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    
    [JFProgressHUD showTextHUDInView:self text:message detailText:nil hideAfterDelay:1.5];
}

#pragma mark - UICollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imagePathsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JFPictureBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JFPictureBrowserCell" forIndexPath:indexPath];
    
    //设置imageview的contentMode
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //设置代理scrollview的代理对象
    cell.scrollView.delegate = self;
    //设置最大伸缩比例
    cell.scrollView.maximumZoomScale = 3.0;
    //设置最小伸缩比例
    cell.scrollView.minimumZoomScale = 1;
    //设置scrollView滚动条
    cell.scrollView.showsHorizontalScrollIndicator = NO;
    cell.scrollView.showsVerticalScrollIndicator = NO;
    
    id imagePath = _imagePathsArray[indexPath.item];
    
    if (!_hasAddedHud)
    {
        _HUD = [JFProgressHUD showWaitingHUDInView:cell text:nil];
        _hasAddedHud = YES;
    }
    
    if ([imagePath isKindOfClass:[NSString class]])
    {
        if ([imagePath hasPrefix:@"http"])
        {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                _currentImage = image;
                [JFProgressHUD hideWithHUD:_HUD afterDelay:0];
                _hasAddedHud = NO;
            }];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:imagePath];
        }
    }
    else if ([imagePath isKindOfClass:[UIImage class]])
    {
        cell.imageView.image = (UIImage *)imagePath;
    }
    
    //添加手势
    [self addGestureOnScrollView:cell.scrollView];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    JFPictureBrowserCell *cell1 = (JFPictureBrowserCell *)cell;
    cell1.scrollView.zoomScale = 1;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //当前显示页数
    int itemIndex = (scrollView.contentOffset.x + self.collectionView.frame.size.width * 0.5) / self.collectionView.frame.size.width;
    
    _pageLabel.text = [NSString stringWithFormat:@"%d/%lu",itemIndex + 1,_imagePathsArray.count];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImageWriteToSavedPhotosAlbum(_currentImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

#pragma mark - 图片缩放相关方法

- (void)addGestureOnScrollView:(UIScrollView *)scrollView
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [scrollView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [scrollView addGestureRecognizer:longPress];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

//单击手势
- (void)singleTapAction:(UITapGestureRecognizer *)tap
{
    self.alpha = 1.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//双击手势
- (void)doubleTapAction:(UITapGestureRecognizer *)tap
{
    UIScrollView *scrollView = (UIScrollView *)tap.view;
    _selectScrollView = scrollView;
    CGFloat scale = 1;
    if (scrollView.zoomScale == 1.0) {
        scale = 3;
    } else {
        scale = 1;
    }
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:[tap locationInView:tap.view]];
    [scrollView zoomToRect:zoomRect animated:YES];
}

//长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否保存该图片？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        [actionSheet showInView:self];
    }
}

//以中心
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = _selectScrollView.frame.size.height / scale;
    zoomRect.size.width  = _selectScrollView.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

#pragma mark - Setter & Getters

- (void)setStartIndex:(NSInteger)startIndex
{
    [_collectionView setContentOffset:CGPointMake((startIndex - 1) * self.frame.size.width + (startIndex - 1) * kItemMargin, 0)];
    _pageLabel.text = [NSString stringWithFormat:@"%lu/%lu",startIndex,_imagePathsArray.count];
}

- (void)setImageURLStringGroup:(NSArray *)imageURLStringGroup
{
    _imageURLStringGroup = imageURLStringGroup;
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
    
    [_imageURLStringGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]])
        {
            urlString = obj;
        }
        else if ([obj isKindOfClass:[NSURL class]])
        {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString)
        {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsArray = [temp copy];
}

- (void)setImageNamesGroup:(NSArray *)imageNamesGroup
{
    _imageNamesGroup = imageNamesGroup;
    
    self.imagePathsArray = [imageNamesGroup copy];
}

- (void)setImageGroup:(NSArray *)imageGroup
{
    _imageGroup = imageGroup;
    
    self.imagePathsArray = [imageGroup copy];
}

- (void)setImagePathsArray:(NSArray *)imagePathsArray
{
    _imagePathsArray = imagePathsArray;
    
    _pageLabel.text = [NSString stringWithFormat:@"1/%lu",imagePathsArray.count];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = kItemMargin;
        layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin/2, 0, kItemMargin/2);
        layout.itemSize = self.bounds.size;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-kItemMargin/2, 0, kViewWidth+kItemMargin, kViewHeight) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"JFPictureBrowserCell" bundle:nil] forCellWithReuseIdentifier:@"JFPictureBrowserCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
    }
    
    return _collectionView;
}

- (UILabel *)pageLabel
{
    if (!_pageLabel)
    {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 30)];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.font = [UIFont systemFontOfSize:16];
    }
    
    return _pageLabel;
}

@end
