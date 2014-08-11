//
//  LightBulbRoomViewController.m
//  Bluetooth
//
//  Created by john on 8/4/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "LightBulbRoomViewController.h"

@interface LightBulbRoomViewController ()

@end

@implementation LightBulbRoomViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImage *home = [UIImage imageNamed:@"home-icon"];
        UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"Home" image:home tag:0];
        self.tabBarItem = homeTab;
    }
    return self;
}

@end
