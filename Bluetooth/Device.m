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

@synthesize configureState;


- (instancetype)init
{
    self = [super init];
    if (self) {
        
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
