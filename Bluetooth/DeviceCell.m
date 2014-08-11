//
//  DeviceCell.m
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "DeviceCell.h"

@implementation DeviceCell


- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.1];
        UIImage *buttonImage = [UIImage imageNamed:@"lightbulb"];
        self.profilePicture = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 80, 80)];
        [self.profilePicture setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self.contentView addSubview:self.profilePicture];

        self.room = [[UILabel alloc]initWithFrame: CGRectMake(100, 0, 200, 30)];
        self.room.textAlignment = NSTextAlignmentLeft;
        self.room.font = [UIFont fontWithName:@"GillSans-Light" size:23.0];
        self.room.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.room];
        
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 200, 30)];
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.font = [UIFont fontWithName:@"GillSans-Light" size:10.0];
        self.name.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.name];

        self.state = [[UILabel alloc]initWithFrame:CGRectMake(250, 30, 50, 50)];
        self.state.textAlignment = NSTextAlignmentRight;
        self.state.font = [UIFont fontWithName:@"GillSans-Light" size:15.0];
        self.state.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.state];
    }
    return self;
}
- (void) buttonTapped {
    NSLog(@"hi");
}

@end
