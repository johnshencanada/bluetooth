//
//  nextDuinoViewController.m
//  nextHome
//
//  Created by john on 11/14/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "nextDuinoViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CNBluetoothCentral.h"

@interface nextDuinoViewController () <CNBluetoothCentralDelegate>
@property (strong,nonatomic) UIButton *toogleButton;
@property BOOL isOn;

@end

@implementation nextDuinoViewController

#pragma mark MVC Lifecycle

- (id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.devices = [NSArray arrayWithArray:devices];
        UIImage *color = [UIImage imageNamed:@"heart"];
        UITabBarItem *colorTab = [[UITabBarItem alloc] initWithTitle:@"nextDuino" image:color tag:0];
        self.tabBarItem = colorTab;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[CNBluetoothCentral sharedBluetoothCentral] setDelegate:self];
    [[CNBluetoothCentral sharedBluetoothCentral] startCentral];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.toogleButton = [[UIButton alloc]initWithFrame:CGRectMake(110, 170, 100, 100)];
    [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"offButton"] forState:UIControlStateNormal];
    [self.toogleButton addTarget:self action:@selector(toogleSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toogleButton];
    self.isOn = false;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[CNBluetoothCentral sharedBluetoothCentral] cleanup];
    [[CNBluetoothCentral sharedBluetoothCentral] setDelegate:nil];
}


#pragma mark View helper

- (void)findCharacteristicsAndConfigure
{
    for (Device *device in self.devices)
    {
        NSLog(@"Device:%@",device);
        
        for (CBService *service in device.peripheral.services)
        {
            for (CBCharacteristic *characteristic in service.characteristics) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
                    device.congigureCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
                    device.onOffCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE4"]]) {
                    device.readCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE9"]]) {
                    device.writeCharacteristic = characteristic;
                }
            }
        }
        
        /* set the configuration characteristics to be configurable */
        [device.peripheral writeValue:device.configurationEnabledData forCharacteristic:device.congigureCharacteristic type:CBCharacteristicWriteWithResponse];
        /* then turn it on */
        [device.peripheral writeValue:device.onData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}



- (void)toogleSwitch
{
    
    for (Device *device in self.devices)
    {
        NSLog(@"Device:%@",device.peripheral.name);
    }
    
    NSLog(@"%lu",(unsigned long)self.devices.count);
    NSString *str;

    if (!self.isOn) {
        [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"onButton"] forState:UIControlStateNormal];
        str = [NSString stringWithFormat:@"o"];
        [[CNBluetoothCentral sharedBluetoothCentral] sendDataWithoutResponse:str];
        self.isOn = true;
        NSLog(@"Sending On data, self.on is :%d", self.isOn);
    }
    
    else {
        [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"offButton"] forState:UIControlStateNormal];
        str = [NSString stringWithFormat:@"c"];
        NSLog(@"Sending Off data");
        [[CNBluetoothCentral sharedBluetoothCentral] sendDataWithoutResponse:str];
        self.isOn = false;
        NSLog(@"Sending On data, self.on is :%d", self.isOn);
    }
    
}

#pragma mark <CNBluetoothCentralDelegate>

- (void)scanStarted
{
    NSLog(@"scan starting");
}

- (void)centralDidNotStart:(NSString *)errorString
{
    NSLog(@"Central Did Not start, Error: %@",errorString);
}

- (void)centralConnectedwithPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error
{
    NSLog(@"Connected");
}

- (void)centralDisconnectwithPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error
{
    NSLog(@"Did Disconnect");
}

- (void)centralReadCharacteristic:(CBCharacteristic *)characteristic withPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error
{
    NSString *temp = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    NSLog(@"%@", temp);
}

- (void)centralWroteCharacteristic:(CBCharacteristic *)characteristic withPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error
{
    NSLog(@"");
}


#pragma mark <CBCentral Delegate>

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
}
@end
