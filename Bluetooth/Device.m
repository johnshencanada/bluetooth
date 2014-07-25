//
//  Device.m
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "Device.h"

@implementation Device
@synthesize peripheral,centralManager;
@synthesize congigureCharacteristic;
@synthesize onOffCharacteristic;
@synthesize readCharacteristic;
@synthesize writeCharacteristic;

@synthesize configurationEnabledData;
@synthesize onData;
@synthesize offData;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.congigureCharacteristic = [[CBCharacteristic alloc]init];
        self.onOffCharacteristic = [[CBCharacteristic alloc]init];
        self.readCharacteristic = [[CBCharacteristic alloc]init];
        self.writeCharacteristic = [[CBCharacteristic alloc]init];
        
        UInt8 configureByte[1];
        configureByte[0] = 0x04;
        self.configurationEnabledData = [NSData dataWithBytes:&configureByte length:sizeof(configureByte)];
        
        UInt8 onByte[1];
        onByte[0]= 0x3f;
        self.onData = [NSData dataWithBytes:&onByte length:sizeof(onByte)];
        
        UInt8 offByte[1];
        offByte[0]= 0x00;
        self.offData = [NSData dataWithBytes:&offByte length:sizeof(offByte)];


    }
    
    return self;
}
@end
