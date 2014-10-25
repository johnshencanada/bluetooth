//
//  ControlPanelView.m
//  Bluetooth
//
//  Created by john on 8/30/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "ControlPanelView.h"

@implementation ControlPanelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        
        UIImage *buttonImage1 = [UIImage imageNamed:@"on"];
        self.toogleSwitch = [[UIButton alloc]initWithFrame:CGRectMake(15, 25, 30, 30)];
        [self.toogleSwitch setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
        [self addSubview:self.toogleSwitch];
        
        self.slider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(55, 25, 200, 30)];
        self.slider.popUpViewCornerRadius = 12.0;
        [self.slider setMaxFractionDigitsDisplayed:0];
        self.slider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
        self.slider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
        self.slider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
        [self addSubview:self.slider];
        
        UIImage *buttonImage2 = [UIImage imageNamed:@"forward"];
        self.go = [[UIButton alloc]initWithFrame:CGRectMake(260, 5, 60, 60)];
        self.go.backgroundColor = [UIColor clearColor];
        [self.go setBackgroundImage:buttonImage2 forState:UIControlStateNormal];
        [self addSubview:self.go];
    }
    return self;
}



@end
