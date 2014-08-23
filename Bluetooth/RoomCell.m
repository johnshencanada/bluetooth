//
//  RoomCell.m
//  Bluetooth
//
//  Created by john on 8/22/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "RoomCell.h"

@implementation RoomCell

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    }
    return self;
}

@end
