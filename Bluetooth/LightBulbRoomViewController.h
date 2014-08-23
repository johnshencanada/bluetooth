//
//  LightBulbRoomViewController.h
//  Bluetooth
//
//  Created by john on 8/4/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface LightBulbRoomViewController : UIViewController

- (id) initWithDevices:(NSArray *)devices;
@property (strong,nonatomic) NSArray *devices;

@end
