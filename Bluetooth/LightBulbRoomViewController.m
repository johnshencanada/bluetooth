//
//  LightBulbRoomViewController.m
//  Bluetooth
//
//  Created by john on 8/4/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "LightBulbRoomViewController.h"
#import "MyNavigationController.h"
#import "CircleCounter.h"

@interface LightBulbRoomViewController ()
@property (strong, nonatomic)  UILabel *daysToGoLabel;
@property (strong, nonatomic)  UILabel *hoursToGoLabel;
@property (strong, nonatomic)  UILabel *minutesToGoLabel;
@property (strong, nonatomic)  UILabel *secondsToGoLabel;
@property  (nonatomic) UIVisualEffectView *vibrancyView;
@property (nonatomic) CircleCounter *circleCounter;


@end

@implementation LightBulbRoomViewController

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        UIImage *home = [UIImage imageNamed:@"home-icon"];
        UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"Home" image:home tag:0];
        self.tabBarItem = homeTab;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [self setUpView];
    
}

- (void) setUpView {
    self.circleCounter = [[CircleCounter alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.circleCounter];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MyNavigationController *nav = self.navigationController;
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:nav.blurEffect];
    self.vibrancyView = [[UIVisualEffectView alloc]initWithEffect:vibrancyEffect];
    self.vibrancyView.frame = self.view.bounds;
    
    
    self.minutesToGoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, 160, 100)];
    self.minutesToGoLabel.textAlignment = NSTextAlignmentLeft;
    self.minutesToGoLabel.font = [UIFont fontWithName:@"GillSans-Light" size:100];
    self.minutesToGoLabel.textColor = [UIColor whiteColor];
    [self.vibrancyView.contentView addSubview:self.minutesToGoLabel];
    
    UILabel *column = [[UILabel alloc]initWithFrame:CGRectMake(150, 220, 20, 100)];
    column.text = [NSString stringWithFormat:@":"];
    column.font = [UIFont fontWithName:@"GillSans-Light" size:100];
    column.textColor =  [UIColor whiteColor];
    [self.vibrancyView.contentView addSubview:column];


    self.secondsToGoLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 220, 160, 100)];
    self.secondsToGoLabel.textAlignment = NSTextAlignmentLeft;
    self.secondsToGoLabel.font = [UIFont fontWithName:@"GillSans-Light" size:100];
    self.secondsToGoLabel.textColor = [UIColor whiteColor];
    [self.vibrancyView.contentView addSubview:self.secondsToGoLabel];

    [nav.blurView.contentView addSubview:self.vibrancyView];


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
