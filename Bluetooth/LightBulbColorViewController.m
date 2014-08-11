//
//  LightBulbColorViewController.m
//  Bluetooth
//
//  Created by john on 8/4/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "LightBulbColorViewController.h"
#import "MyNavigationController.h"

@interface LightBulbColorViewController ()
@property (nonatomic) UIView *colorView;
@property  (nonatomic) UIVisualEffectView *vibrancyView;

@end

@implementation LightBulbColorViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];


    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(0, ((self.view.frame.size.height)/2 - 160), 320, 320)];

    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];

    _wellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _wellView.layer.borderColor = [UIColor blackColor].CGColor;
    _wellView.layer.borderWidth = 1.0;
    [self.view addSubview:_wellView];
}

- (void)changeBrightness:(UISlider*)sender
{
    [_colorWheel setBrightness:_brightnessSlider.value];
    [_colorWheel updateImage];
    [_wellView setBackgroundColor:_colorWheel.currentColor];
}

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    [_wellView setBackgroundColor:_colorWheel.currentColor];
}


@end
