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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toogleButton = [[UIButton alloc]initWithFrame:CGRectMake(110, 170, 100, 100)];
    [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"offButton"] forState:UIControlStateNormal];
    [self.toogleButton addTarget:self action:@selector(toogleSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toogleButton];
    self.isOn = false;
}

- (void)toogleSwitch
{
    NSLog(@"I am tapped");
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
        self.isOn = false;
        NSLog(@"Sending On data, self.on is :%d", self.isOn);
    }
    
}

#pragma mark <CNBluetoothCentralDelegate>

- (void)scanStarted
{
    
}

- (void)centralDidNotStart:(NSString *)errorString
{
    
}

- (void)centralConnectedwithPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error
{
    
}

- (void)centralDisconnectwithPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error
{
    
}

- (void)centralReadCharacteristic:(CBCharacteristic *)characteristic withPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error
{
    
}

- (void)centralWroteCharacteristic:(CBCharacteristic *)characteristic withPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error
{
    
}
@end
