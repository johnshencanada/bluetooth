//
//  ClockCell.m
//  nextHome
//
//  Created by john on 12/18/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "ClockCell.h"

@implementation ClockCell

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    
        BEMAnalogClockView *myClock = [[BEMAnalogClockView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        myClock.delegate = self;
        
        /* Color */
        myClock.faceBackgroundColor = [UIColor clearColor];
        myClock.borderAlpha = 0.7;
        myClock.enableGraduations = NO;
        myClock.enableShadows = NO;
        
        /* Size */
        myClock.hourHandWidth = 1.5;
        myClock.hourHandLength = 1;
        
        myClock.minuteHandWidth = 1;
        myClock.minuteHandLength = 1.0;
        
        myClock.secondHandWidth = 0.5;
        myClock.secondHandLength = 1;
        [self addSubview:myClock];

        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 100, 50)];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
        self.timeLabel.text = [NSString stringWithFormat:@"8:00 AM"];
        [self addSubview:self.timeLabel];
        
        self.actionLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 40, 50, 50)];
        self.actionLabel.textColor = [UIColor whiteColor];
        self.actionLabel.textAlignment = NSTextAlignmentCenter;
        self.actionLabel.font = [UIFont fontWithName:@"GillSans" size:30.0];
        self.actionLabel.text = [NSString stringWithFormat:@"On"];
        [self addSubview:self.actionLabel];
        
        self.enableSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(250, 50, 60, 30)];
        [self addSubview:self.enableSwitch];
    }
    return self;
}


@end
