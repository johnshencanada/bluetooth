//
//  LightBulbColorViewController.m
//  Bluetooth
//
//  Created by john on 8/4/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "LightBulbColorViewController.h"
#import "MyNavigationController.h"

@interface LightBulbColorViewController ()
@property (nonatomic) UIView *colorView;
@property  (nonatomic) UIVisualEffectView *vibrancyView;
@end

@implementation LightBulbColorViewController

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.devices = devices;
        UIImage *color = [UIImage imageNamed:@"colorwheel-icon"];
        UITabBarItem *colorTab = [[UITabBarItem alloc] initWithTitle:@"Color" image:color tag:0];
        self.tabBarItem = colorTab;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(0, ((self.view.frame.size.height)/2 - 160), 320, 320)];

    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];

    _wellView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 50, 50)];
    _wellView.layer.borderWidth = 1.0;
    [self.view addSubview:_wellView];
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

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [_colorWheel.currentColor getRed:&red green:&green blue:&blue alpha:&alpha];

    [_wellView setBackgroundColor:_colorWheel.currentColor];
    
    double r = (int)(red * 255);
    double g = (int)(green * 255);
    double b = (int)(blue * 255);
    
    NSLog(@"R:%f, G:%f, B:%f",r,g,b);

    for (Device *device in self.devices) {
        NSLog(@"HI");
        [device changeColorWithRed:r andGreen:g andBlue:b];
        [device.peripheral writeValue:device.colorData forCharacteristic:device.writeCharacteristic type:CBCharacteristicWriteWithResponse];

    }

}


@end
