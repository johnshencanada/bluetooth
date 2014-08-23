//
//  Dashboard.m
//  Bluetooth
//
//  Created by john on 8/16/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "Dashboard.h"

@implementation Dashboard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.homeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        self.homeLabel.text = [NSString stringWithFormat:@"John's Home"];
        self.homeLabel.textAlignment = NSTextAlignmentLeft;
        self.homeLabel.font = [UIFont fontWithName:@"GillSans-Light" size:30.0];
        self.homeLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.homeLabel];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
}

@end
