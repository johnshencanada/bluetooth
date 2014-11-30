//
//  LightBulbColorViewController.m
//  Bluetooth
//
//  Created by john on 8/4/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "LightBulbColorViewController.h"
#import "MyNavigationController.h"
#import "BrightnessView.h"
#import "CircleCounter.h"

@interface LightBulbColorViewController ()
@property (strong,nonatomic) MyNavigationController *nav;
@property (strong,nonatomic) UIVisualEffect *vibrancyEffect;
@property  (strong,nonatomic) UIVisualEffectView *vibrancyView;
@property (nonatomic) BrightnessView *brightView;
@property (strong,nonatomic) UIButton *toogleButton;

@property (strong,nonatomic) UIButton *brightnessButton;
@property (strong,nonatomic) UIButton *warmnessButton;
@property (strong,nonatomic) ASValueTrackingSlider *brightSlider;
@property (strong,nonatomic) ASValueTrackingSlider *warmSlider;

@property (strong, nonatomic) CircleCounter *background;
@property BOOL isOn;

@property int percentage;
@end

@implementation LightBulbColorViewController

- (id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.devices = [NSArray arrayWithArray:devices];
        UIImage *color = [UIImage imageNamed:@"heart"];
        UITabBarItem *colorTab = [[UITabBarItem alloc] initWithTitle:@"Color" image:color tag:0];
        self.tabBarItem = colorTab;
        [self findCharacteristicsAndConfigure];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpBlurAndVibrancy];
    
    self.background = [[CircleCounter alloc] initWithFrame:CGRectMake(20, ((self.view.frame.size.height)/2 - 210), 280, 280)];
    self.background.backgroundColor = [UIColor clearColor];
    self.background.circleColor = [UIColor colorWithRed:255/255.0f  green:255/255.0f  blue:255/255.0f  alpha:0.1];
    self.background.circleWidth = 6.0f;
    [self.view addSubview:self.background];

    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(25, ((self.view.frame.size.height)/2 - 205), 270, 270)];
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];
    
    self.toogleButton = [[UIButton alloc]initWithFrame:CGRectMake(110, 170, 100, 100)];
    [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"onButton"] forState:UIControlStateNormal];
    [self.toogleButton addTarget:self action:@selector(toogleSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toogleButton];
    
    [self setUpBrightnessView];
}

- (void) setUpBlurAndVibrancy
{
    self.nav = self.navigationController;
    self.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:self.nav.blurEffect];
    self.vibrancyView = [[UIVisualEffectView alloc]initWithEffect:self.vibrancyEffect];
    self.vibrancyView.frame = self.view.bounds;
    [self.nav.blurView.contentView addSubview:self.vibrancyView];
}

- (void)setUpBrightnessView
{
    UIImage *brightnessImage = [UIImage imageNamed:@"brightness"];
    UIImage *warmImage = [UIImage imageNamed:@"warm"];

    self.brightnessButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 390, 25, 25)];
    [self.brightnessButton setBackgroundImage:brightnessImage forState:UIControlStateNormal];
    [self.view addSubview:self.brightnessButton];
    [self.brightnessButton addTarget:self action:@selector(brightnessButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.brightSlider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(50, 390, 240, 30)];
    self.brightSlider.popUpViewCornerRadius = 12.0;
    self.brightSlider.maximumValue = 1.00;
    [self.brightSlider setMaxFractionDigitsDisplayed:0];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    [self.brightSlider setNumberFormatter:formatter];
    self.brightSlider.popUpViewColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.brightSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.brightSlider.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.brightSlider];
    
    self.warmnessButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 450, 25, 25)];
    [self.warmnessButton setBackgroundImage:warmImage forState:UIControlStateNormal];
    [self.view addSubview:self.warmnessButton];
    [self.warmnessButton addTarget:self action:@selector(brightnessButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.warmSlider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(50, 450, 240, 30)];
    self.warmSlider.popUpViewCornerRadius = 12.0;
    self.warmSlider.maximumValue = 1.00;
    [self.warmSlider setMaxFractionDigitsDisplayed:0];
    [self.warmSlider setNumberFormatter:formatter];
    self.warmSlider.popUpViewColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.warmSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.warmSlider.textColor = [UIColor whiteColor];
    [self.view addSubview:self.warmSlider];
    
    self.isOn = true;
}


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

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [_colorWheel.currentColor getRed:&red green:&green blue:&blue alpha:&alpha];
    [self.background setColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.5]];
    [self.brightSlider setPopUpViewColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.5]];
    [self.warmSlider setPopUpViewColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.5]];

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

- (void)toogleSwitch
{
    NSLog(@"I am tapped");
    NSLog(@"%lu",(unsigned long)self.devices.count);
    
    for(Device *device in self.devices) {
        NSLog(@"UUID: %@",device.peripheral.identifier);
    }
    
    if (!self.isOn) {
        [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"onButton"] forState:UIControlStateNormal];
        for(Device *device in self.devices) {
            [device.peripheral writeValue:device.onData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
        }
        self.isOn = true;
        NSLog(@"Sending On data, self.on is :%d", self.isOn);
    }
    
    else {
        [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"offButton"] forState:UIControlStateNormal];
        NSLog(@"Sending Off data");
        for(Device *device in self.devices) {
            [device.peripheral writeValue:device.offData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
        }
        self.isOn = false;
        NSLog(@"Sending On data, self.on is :%d", self.isOn);
    }
}

- (void)brightnessButtonClicked:sender
{
    [self startShake:sender];
    [self.brightSlider setPopUpViewColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.warmSlider setPopUpViewColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    self.background.circleColor = [UIColor colorWithRed:255/255.0f  green:255/255.0f  blue:255/255.0f  alpha:0.1];
    for (Device *device in self.devices) {
        [device changeBrightness:255];
        [device.peripheral writeValue:device.colorData forCharacteristic:device.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}


#pragma mark <shaking animation>

- (void) startShake:(UIView *)view
{
    CGAffineTransform normal = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform leftShake = CGAffineTransformMakeTranslation(0, -5);
    CGAffineTransform rightShake = CGAffineTransformMakeTranslation(0, 5);
    
    view.transform = leftShake;  // starting point
    
    [UIView beginAnimations:@"shake_button"context:NULL];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    view.transform = rightShake;
    view.transform = normal;  // end here & auto-reverse
    [UIView commitAnimations];
}

@end
