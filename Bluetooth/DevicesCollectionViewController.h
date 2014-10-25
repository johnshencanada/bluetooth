//
//  DevicesCollectionViewController.h
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "Device.h"
#import <UIKit/UIKit.h>
#import <HomeKit/HomeKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DevicesCollectionViewController : UICollectionViewController <CBCentralManagerDelegate,CBPeripheralDelegate, HMHomeManagerDelegate >
- (instancetype)initWithName:(NSString *)name;

@end
