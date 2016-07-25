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
    NSArray *imageUrlArray = @[@"http://img15.3lian.com/2015/f2/15/d/142.jpg",
                               @"http://www.pp3.cn/uploads/201509/2015091507.jpg",
                               @"http://s16.sinaimg.cn/mw690/48859953gdffa5856d7df&690"];
    
    [JFPictureBrowserView clearImagesCache];
    
    JFPictureBrowserView *pictureBrowserView = [JFPictureBrowserView pictureBrowsweViewWithFrame:self.view.frame delegate:self imageURLStringGroup:imageUrlArray];
    pictureBrowserView.startIndex = 1;//开始索引
    [pictureBrowserView showInView:self.view];
}

@end
