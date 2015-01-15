//
//  HomeViewController.m
//  Bluetooth
//
//  Created by john on 9/11/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (nonatomic) UIButton *back;
@end

@implementation HomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"HI");
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /* blur effect background */
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 600)];
    imageView.image = [UIImage imageNamed:@"house"];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    [self setBackImage:@"back"];
    [self.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setBackImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 25, 25)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.back];
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
