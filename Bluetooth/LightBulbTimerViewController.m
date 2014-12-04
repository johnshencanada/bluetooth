//
//  LightBulbTimerViewController.m
//  Bluetooth
//
//  Created by john on 8/29/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "LightBulbTimerViewController.h"
#import "MyNavigationController.h"
#import "CircleCounter.h"

@interface LightBulbTimerViewController ()
@property (nonatomic) MyNavigationController *nav;
@property (nonatomic) UIVibrancyEffect *vibrancyEffect;
@property  (nonatomic) UIVisualEffectView *vibrancyView;
@property (nonatomic) UIView *colorView;

@property (strong, nonatomic)  UILabel *daysToGoLabel;
@property (strong, nonatomic)  UILabel *hoursToGoLabel;
@property (strong, nonatomic)  UILabel *minutesToGoLabel;
@property (strong, nonatomic)  UILabel *secondsToGoLabel;
@property (nonatomic) CircleCounter *circleCounter;
@end

@implementation LightBulbTimerViewController

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        UIImage *timer = [UIImage imageNamed:@"timer"];
        UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"Timer" image:timer tag:0];
        self.tabBarItem = homeTab;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [self setUpBlurAndVibrancy];
    [self setUpView];
}

- (void) setUpView {
    self.circleCounter = [[CircleCounter alloc] initWithFrame:self.view.frame];
    self.circleCounter.circleColor = [UIColor colorWithRed:129/255.0f  green:243/255.0f  blue:253/255.0f  alpha:1.0];
    self.circleCounter.circleWidth = 8.0f;
    [self.view addSubview:self.circleCounter];
}


- (void) setUpBlurAndVibrancy
{
    self.nav = self.navigationController;
    self.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:self.nav.blurEffect];
    self.vibrancyView = [[UIVisualEffectView alloc]initWithEffect:self.vibrancyEffect];
    self.vibrancyView.frame = self.view.bounds;
    [self.nav.blurView addSubview:self.vibrancyView];
}


- (void)viewDidLoad
{
    [self findCharacteristicsAndConfigure];
}

- (void)findCharacteristicsAndConfigure
{
    for (Device *device in self.devices) {
        device.isOn = false;
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

- (void) viewWillDisappear:(BOOL)animated
{
    
}
@end
