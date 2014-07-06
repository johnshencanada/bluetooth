//
//  Device.h
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface Device : NSObject
@property (strong,nonatomic) CBPeripheral *peripheral;
@property (strong,nonatomic) CBCentralManager *centralManager;

@end
