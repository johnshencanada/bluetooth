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
@property (strong,nonatomic) ASValueTrackingSlider *brightSlider;
@property (strong,nonatomic) ASValueTrackingSlider *warmSlider;

@property (strong, nonatomic) CircleCounter *brightness;
@property (strong, nonatomic) CircleCounter *cold;
@property (strong, nonatomic) CircleCounter *warm;
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
    
    self.brightness = [[CircleCounter alloc] initWithFrame:CGRectMake(20, ((self.view.frame.size.height)/2 - 210), 280, 280)];
    self.brightness.backgroundColor = [UIColor clearColor];
    self.brightness.circleColor = [UIColor colorWithRed:255/255.0f  green:255/255.0f  blue:255/255.0f  alpha:0.1];
    self.brightness.circleWidth = 6.0f;
    [self.view addSubview:self.brightness];

    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(25, ((self.view.frame.size.height)/2 - 205), 270, 270)];
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];
    
    self.toogleButton = [[UIButton alloc]initWithFrame:CGRectMake(110, 170, 100, 100)];
    [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"number-device"] forState:UIControlStateNormal];
    [self.toogleButton addTarget:self action:@selector(toogleSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toogleButton];
    
    [self setUpBrightnessView];
    [self setUpCircleButtons];
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
    self.brightSlider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(40, 400, 240, 30)];
    self.brightSlider.popUpViewCornerRadius = 12.0;
    [self.brightSlider setMaxFractionDigitsDisplayed:2];
    self.brightSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    self.brightSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.brightSlider.textColor = [UIColor whiteColor];
    [self.view addSubview:self.brightSlider];
    
    self.warmSlider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(40, 450, 240, 30)];
    self.warmSlider.popUpViewCornerRadius = 12.0;
    [self.warmSlider setMaxFractionDigitsDisplayed:2];
    self.warmSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    self.warmSlider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.warmSlider.textColor = [UIColor whiteColor];
    [self.view addSubview:self.warmSlider];
}

- (void)setUpCircleButtons
{
    self.warm = [[CircleCounter alloc] initWithFrame:self.vibrancyView.bounds];
    self.warm.circleColor = [UIColor colorWithRed:129/255.0f  green:243/255.0f  blue:253/255.0f  alpha:1.0];
    self.warm.circleWidth = 2.0f;
    [self.vibrancyView.contentView addSubview:self.warm];
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
                    NSLog(@"Found FFF1");
                    device.congigureCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
                    NSLog(@"Found FFF2");
                    device.onOffCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE4"]]) {
                    NSLog(@"Found FFE4");
                    device.readCharacteristic = characteristic;
                }
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE9"]]) {
                    NSLog(@"Found FFE9");
                    device.writeCharacteristic = characteristic;
                }
            }
        }
        
        /* set the configuration characteristics to be configurable */
        [device.peripheral writeValue:device.configurationEnabledData forCharacteristic:device.congigureCharacteristic type:CBCharacteristicWriteWithResponse];
        /* then turn it on */
        [device.peripheral writeValue:device.onData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
        self.isOn = true;
    }
}

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [_colorWheel.currentColor getRed:&red green:&green blue:&blue alpha:&alpha];
    [self.brightness setColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.8]];
    [self.brightSlider setPopUpViewColor:[UIColor colorWithRed:red green:green blue:blue alpha:0.5]];
    
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
    NSLog(@"%d",self.devices.count);
    
    for(Device *device in self.devices) {
        NSLog(@"UUID: %@",device.peripheral.identifier);
    }
    
    if (!self.isOn ) {
        NSLog(@"Sending On data");
        for(Device *device in self.devices) {
            [device.peripheral writeValue:device.onData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
            self.isOn = true;
        }
    }
    
    else {
        NSLog(@"Sending Off data");
        for(Device *device in self.devices) {
            [device.peripheral writeValue:device.offData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
            self.isOn = false;
        }
    }
    
    [self.toogleButton setBackgroundImage:[UIImage imageNamed:@"offButton"] forState:UIControlStateNormal];
}

- (void)adjustBrightness:(UIPanGestureRecognizer *)panGesture
{
    CGPoint vel = [panGesture velocityInView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        if (vel.y > 0)
        {
            if (self.percentage >= 2) {
                self.percentage -=2;
                NSLog(@"%d",self.percentage);
                
                for(Device *device in self.devices) {
                    [device decrementBrightnessBy:5.12];
                }
                [self.brightView decreaseHeight];
            }
        }
        
        if (vel.y < 0)
        {
            if (self.percentage < 99) {
                self.percentage +=2;
                NSLog(@"%d",self.percentage);
                
                for(Device *device in self.devices) {
                    [device incrementBrightnessBy:5.12];
                }
                [self.brightView increaseHeight];
            }
        }
    }
    for(Device *device in self.devices) {
        NSLog(@"%@",device.colorData);
        [device.peripheral writeValue:device.colorData forCharacteristic:device.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}


@end
