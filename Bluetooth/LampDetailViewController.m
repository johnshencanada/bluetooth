//
//  LampDetailViewController.m
//  Bluetooth
//
//  Created by john on 7/5/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "LampDetailViewController.h"

@interface LampDetailViewController ()

@end

@implementation LampDetailViewController


-(id) initWithDevice:(Device *)device
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.lamp = device;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.power = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.power.frame = CGRectMake(100, 100, 100, 100);
    
    [self.power addTarget:self
               action:@selector(sendDataWithoutResponse)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.power setTitle:@"OFF" forState:UIControlStateNormal];
    [self.view addSubview:self.power];
    
}


#pragma mark Helper Methods

- (BOOL)sendDataWithoutResponse
{
    NSString *dataStr = [NSString stringWithFormat:@"b"];
    CBCharacteristic *tmpCharacteristic;
    
    for (CBService *service in self.lamp.peripheral.services)
    {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            // And check if it's the right one
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCNCoinBLEWriteCharacteristicUUID]])
            {
                
                tmpCharacteristic = characteristic;
                break;
            }
        }
    }
    
    if (tmpCharacteristic == nil)
    {
        return NO;
    }
    
    
    //Cut and send in 20 character size
    NSString *tmpStr;
    int x = 0;
    
    for (x = 0; x + 20 < [dataStr length]; x = x + 20)
    {
        tmpStr = [dataStr substringWithRange:NSMakeRange(x, 20)];
        
        if ([tmpCharacteristic.UUID isEqual:[CBUUID UUIDWithString:kCNCoinBLEWriteCharacteristicUUID]])
        {
            [self.lamp.peripheral writeValue:[tmpStr dataUsingEncoding:NSUTF8StringEncoding]
                                forCharacteristic:tmpCharacteristic
                                             type:CBCharacteristicWriteWithResponse];
        }
    }
    
    [self.lamp.peripheral writeValue:[[dataStr substringWithRange:NSMakeRange(x, [dataStr length] - x)] dataUsingEncoding:NSUTF8StringEncoding]
                        forCharacteristic:tmpCharacteristic
                                     type:CBCharacteristicWriteWithResponse];
    return YES;
}

#pragma mark - CBCentralManager delegate function

-(void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
}


#pragma mark - CBPeripheral delegate function

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
}



@end
