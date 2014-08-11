//
//  LightBulbDetailViewController.m
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "MyNavigationController.h"
#import "LightBulbDetailViewController.h"
#import "CircleCounter.h"

@interface LightBulbDetailViewController ()
@property (nonatomic) CircleCounter *circleCounter;
@property (nonatomic) UIView *switchView;
@property  (nonatomic) UIVisualEffectView *vibrancyView;
@property (strong,nonatomic) NSNumber *rssi;
@property (strong, nonatomic)  UILabel *rssiLabel;
@end

@implementation LightBulbDetailViewController


#pragma mark - MVC

- (id) initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.devices = devices;
        UIImage *brightness = [UIImage imageNamed:@"lightbulb-icon"];
        UITabBarItem *brightnessTab = [[UITabBarItem alloc] initWithTitle:@"Brightness" image:brightness tag:0];
        self.tabBarItem = brightnessTab;
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
    // This is the code for proximity sensing, Comment it for now
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateRSSI) userInfo:nil repeats:YES];
}

- (void) viewDidAppear:(BOOL)animated
{
    [self findCharacteristicsAndConfigure];
    self.title = [NSString stringWithFormat:@"%@", self.lightBulb.room];
    [self setUpView];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.vibrancyView removeFromSuperview];
}

- (void) setUpView
{
    self.rssiLabel = [[UILabel alloc]initWithFrame: CGRectMake(50, 50, 140, 50)];
    self.rssiLabel.textAlignment = NSTextAlignmentLeft;
    self.rssiLabel.font = [UIFont fontWithName:@"GillSans-Light" size:23.0];
    self.rssiLabel.textColor = [UIColor whiteColor];
    
    MyNavigationController *nav = self.navigationController;
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:nav.blurEffect];
    self.vibrancyView = [[UIVisualEffectView alloc]initWithEffect:vibrancyEffect];
    self.vibrancyView.frame = self.view.bounds;
    self.switchView = [[UIView alloc]initWithFrame:CGRectMake(0, ((self.view.frame.size.height)/2 - 160), 320, 320)];
    self.circleCounter = [[CircleCounter alloc] initWithFrame:self.switchView.frame];
    [self.switchView addSubview:self.circleCounter];
    [self.view addSubview:self.switchView];
    [self.vibrancyView.contentView addSubview:self.circleCounter];
    [nav.blurView.contentView addSubview:self.vibrancyView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(adjustBrightness:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toogleSwitch)];
    tap.numberOfTapsRequired = 1;
    [self.switchView addGestureRecognizer:tap];
    [self.switchView addGestureRecognizer:pan];
    
}

- (void)findCharacteristicsAndConfigure
{
    self.lightBulb.isOn = false;
    for (Device *device in self.devices) {
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
        device.isOn = true;
    }
}

- (void) toogleSwitch
{
    for(Device *device in self.devices) {
        
        if (device.isOn == false) {
            [device.peripheral writeValue:device.onData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
            device.isOn = true;
        }
    
        else if(device.isOn == true ) {
            [device.peripheral writeValue:device.offData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
            device.isOn = false;
        }
    }
}

- (void)adjustBrightness:(UIPanGestureRecognizer *)panGesture
{
    CGPoint vel = [panGesture velocityInView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        if (vel.y > 0)
        {
            for(Device *device in self.devices) {
                [device decrementBrightnessBy:5.12];
            }
            [self.circleCounter decrementBy:2];
        }
        
        if (vel.y < 0) {
            for(Device *device in self.devices) {
                [device incrementBrightnessBy:5.12];
            }
            [self.circleCounter incrementBy:2];
        }
    }
    for(Device *device in self.devices) {
        NSLog(@"%@",device.colorData);
        [device.peripheral writeValue:device.colorData forCharacteristic:device.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)updateRSSI
{
    if (self.lightBulb.peripheral){
        [self.lightBulb.peripheral readRSSI];
        NSLog(@"gAYYY");
        self.rssiLabel.text = [NSString stringWithFormat:@"RSSI: %@",self.rssi];
    }
    else {
        self.rssiLabel.text = [NSString stringWithFormat:@"RSSI: %@",[NSNumber numberWithInt:0]];
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


#pragma mark - CBPeripheral delegate function

/* readRSSI is called */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"error: %@",error);
    }
    self.rssi = peripheral.RSSI;
    NSLog(@"The RSSI is: %@",self.rssi);
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
