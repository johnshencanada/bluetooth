//
//  LightBulbDetailViewController.m
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "LightBulbDetailViewController.h"

@interface LightBulbDetailViewController ()

@end

@implementation LightBulbDetailViewController


#pragma mark - MVC

-(id) initWithDevice:(Device *)device
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.lightBulb = device;
    }
    return self;
}

- (void)viewDidLoad
{
    /* if it's not connected */
    if (self.lightBulb.peripheral.state == 0) {
        self.lightBulb.centralManager.delegate = self;
        [self.lightBulb.centralManager connectPeripheral:self.lightBulb.peripheral options:nil];
    } else {
        self.lightBulb.peripheral.delegate = self;
    }
}

- (void) viewDidAppear:(BOOL)animated
{


    self.title = [NSString stringWithFormat:@"%@", self.lightBulb.peripheral.name];
    self.rssiLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.rssiLabel.textColor = [UIColor whiteColor];
    [self.lightBulb.peripheral readRSSI];
    self.rssiLabel.text = [NSString stringWithFormat:@"0%%"];
    [self.view addSubview:self.rssiLabel];
    
    self.identifierLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 100)];
    self.identifierLabel.textColor = [UIColor whiteColor];
    self.identifierLabel.font = [UIFont fontWithName:@"Gill Sans" size:10.0];

    self.identifierLabel.text = [NSString stringWithFormat:@"%@", self.lightBulb.peripheral.identifier];
    [self.view addSubview:self.identifierLabel];
    
    self.on = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.on.frame = CGRectMake(200, 120, 320, 100);
    [self.on addTarget:self action:@selector(turnOn) forControlEvents:UIControlEventTouchUpInside];
    self.on.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.on];
    
    
    self.lightBulb.isOn = false;
//    UInt8 bytes[1];
//    bytes[0] = 0x04;
//    NSData *dataToSend = [NSData dataWithBytes:&bytes length:sizeof(bytes)];
//    [self.lightBulb.peripheral writeValue:dataToSend forCharacteristic:self.lightBulb.congigureCharacteristic type:CBCharacteristicWriteWithResponse];
//    
//    CBCharacteristic *characteristic =
//    [self.lightBulb.peripheral.services findCharacteristicFromUUID:@"FFF2" service:@"FFF0"];
//    [self.lightBulb.peripheral writeValue:dataToSend forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}


- (void) turnOn
{

    if (self.lightBulb.isOn == false) {
        [self.lightBulb.peripheral writeValue:self.lightBulb.onData forCharacteristic:self.lightBulb.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
        self.lightBulb.isOn = true;
        
    } else if(self.lightBulb.isOn == true ) {
        [self.lightBulb.peripheral writeValue:self.lightBulb.offData forCharacteristic:self.lightBulb.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
        self.lightBulb.isOn = false;
    }

}


#pragma mark - CBCentralManager delegate function

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
//    [central scanForPeripheralsWithServices:nil options:nil];

}
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
//    [central connectPeripheral:peripheral options:nil];
    
}
-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
//    NSLog(@"Connected");

}

#pragma mark - CBPeripheral delegate function

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"hi");
    if (error) {
        NSLog(@"Error writing characteristic value: %@", [error localizedDescription]);
    }
}

@end
