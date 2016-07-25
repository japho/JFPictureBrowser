//
//  JFPictureBrowserCell.h
//  JFPictureBrowser
//
//  Created by Japho on 16/3/14.
//  Copyright © 2016年 Japho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFPictureBrowserCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
