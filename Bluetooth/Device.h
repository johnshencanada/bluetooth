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

@property (strong,nonatomic) CBCharacteristic *congigureCharacteristic;
@property (strong,nonatomic) CBCharacteristic *onOffCharacteristic;
@property (strong,nonatomic) CBCharacteristic *readCharacteristic;
@property (strong,nonatomic) CBCharacteristic *writeCharacteristic;

@property (strong,nonatomic) NSData *configureState;
@property (strong,nonatomic) NSData *onData;
@property (strong,nonatomic) NSData *offData;

@property bool isOn;
@end
