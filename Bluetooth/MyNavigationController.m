//
//  MyNavigationController.m
//  Bluetooth
//
//  Created by john on 7/2/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "MyNavigationController.h"
@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* blur effect background */
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 600)];
    imageView.image = [UIImage imageNamed:@"house"];
    [self.view addSubview:imageView];
    self.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView =  [[UIVisualEffectView alloc]initWithEffect:self.blurEffect];
    self.blurView.frame = imageView.bounds;
    [imageView addSubview:self.blurView];
    [self.view sendSubviewToBack:imageView];

    self.navigationBar.barTintColor = [UIColor blackColor];
    self.toolbar.barTintColor =[UIColor blackColor];
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.toolbar.barStyle = UIBarStyleBlackOpaque;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"refresh" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
