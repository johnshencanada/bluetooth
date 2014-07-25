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

    [self findCharacteristics];
    self.title = [NSString stringWithFormat:@"%@", self.lightBulb.peripheral.name];
    MyNavigationController *nav = self.navigationController;
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:nav.blurEffect];
    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc]initWithEffect:vibrancyEffect];
    vibrancyView.frame = self.view.bounds;

    self.switchView = [[UIView alloc]initWithFrame:CGRectMake(0, ((self.view.frame.size.height)/2 - 160), 320, 320)];
    self.circleCounter = [[CircleCounter alloc] initWithFrame:self.switchView.frame];
    [self.switchView addSubview:self.circleCounter];
    [self.view addSubview:self.switchView];
    
    [vibrancyView.contentView addSubview:self.circleCounter];
    [nav.blurView.contentView addSubview:vibrancyView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(adjustBrightness:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toogleSwitch)];
    tap.numberOfTapsRequired = 1;
    
    [self.switchView addGestureRecognizer:tap];
    [self.switchView addGestureRecognizer:pan];


}

- (void)findCharacteristics
{
    self.lightBulb.isOn = false;

    for (CBService *service in self.lightBulb.peripheral.services)
    {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
                self.lightBulb.congigureCharacteristic = characteristic;
            }
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
                self.lightBulb.onOffCharacteristic = characteristic;
            }
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE9"]]) {
                self.lightBulb.readCharacteristic = characteristic;
            }
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE4"]]) {
                self.lightBulb.writeCharacteristic = characteristic;
                
            }
        }
    }
}

- (void) toogleSwitch
{
    if (self.lightBulb.isOn == false) {
        [self.lightBulb.peripheral writeValue:self.lightBulb.onData forCharacteristic:self.lightBulb.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
        self.lightBulb.isOn = true;
        
    } else if(self.lightBulb.isOn == true ) {
        [self.lightBulb.peripheral writeValue:self.lightBulb.offData forCharacteristic:self.lightBulb.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
        self.lightBulb.isOn = false;
    }
}

- (void)adjustBrightness:(UIPanGestureRecognizer *)panGesture
{
    CGPoint vel = [panGesture velocityInView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        if (vel.y > 0)
        {
            [self.circleCounter increment];
        }
        
        if (vel.y < 0) {
            [self.circleCounter decrement];
        }
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
