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
        
        self.name = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, 200, 30)];
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.font = [UIFont fontWithName:@"Gill Sans" size:23.0];
        self.name.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.name];
        
        self.identifier = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 200, 30)];
        self.identifier.textAlignment = NSTextAlignmentLeft;
        self.identifier.font = [UIFont fontWithName:@"Gill Sans" size:10.0];
        self.identifier.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.identifier];

        self.state = [[UILabel alloc]initWithFrame:CGRectMake(250, 30, 50, 50)];
        self.state.textAlignment = NSTextAlignmentRight;
        self.state.font = [UIFont fontWithName:@"Gill Sans" size:15.0];
        self.state.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.state];


    
    }
    return self;
}


@end
