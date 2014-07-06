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
    self.rssiLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.rssiLabel.textColor = [UIColor whiteColor];
    [self.lightBulb.peripheral readRSSI];
    
    
    self.rssiLabel.text = [NSString stringWithFormat:@"0%%"];
    [self.lightBulb.peripheral readRSSI];
    [self.view addSubview:self.rssiLabel];
}


#pragma mark - CBCentralManager delegate function

-(void) centralManagerDidUpdateState:(CBCentralManager *)central {
    
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {

}

#pragma mark - CBPeripheral delegate function

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
}

@end
