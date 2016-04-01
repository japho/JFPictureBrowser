//
//  ViewController.m
//  JFPictureBrowser
//
//  Created by Japho on 16/3/14.
//  Copyright © 2016年 Japho. All rights reserved.
//

#import "ViewController.h"
#import "JFPictureBrowserView.h"

@interface ViewController () <JFPictureBrowserViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)displayButtonPressed:(id)sender
{
    NSArray *imageUrlArray = @[
                               @"http://img5.imgtn.bdimg.com/it/u=4246510199,2069483326&fm=21&gp=0.jpg",
                               @"http://img1.3lian.com/img13/c1/81/72.jpg",
                               @"http://p14.go007.com/2015_03_11_20/e849316f573e2082_0_min.jpg",
                               @"http://img1.3lian.com/img2011/04/03/s/136.jpg",
                               @"http://img1.3lian.com/img2012/12/46/30.jpg",
                               @"http://www.qq745.com/uploads/allimg/150408/1-15040PJ142-51.jpg",
                               @"http://img5.paipaiimg.com/00000000/item-557D86B9-8967D6450000000004010000512FFD85.0.160x160.jpg"
                               ];
    
    [JFPictureBrowserView clearImagesCache];
    
    JFPictureBrowserView *pictureBrowserView = [JFPictureBrowserView pictureBrowsweViewWithFrame:self.view.frame delegate:self imageURLStringGroup:imageUrlArray];
    pictureBrowserView.startIndex = 1;//开始索引
    [self.view addSubview:pictureBrowserView];
    
    pictureBrowserView.alpha = 0.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        pictureBrowserView.alpha = 1.0;
    } completion:nil];
}

@end
