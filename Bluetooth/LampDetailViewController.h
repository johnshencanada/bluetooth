//
//  LampDetailViewController.h
//  Bluetooth
//
//  Created by john on 7/5/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

#define kCNCoinBLEServiceUUID @"3870cd80-fc9c-11e1-a21f-0800200c9a66"
#define kCNCoinBLEWriteCharacteristicUUID @"E788D73B-E793-4D9E-A608-2F2BAFC59A00"
#define kCNCoinBLEReadCharacteristicUUID @"4585C102-7784-40B4-88E1-3CB5C4FD37A3"

@interface LampDetailViewController : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate>
@property (strong,nonatomic) Device *lamp;
@property (nonatomic) UIButton *power;

-(id) initWithDevice:(Device *)device;

@end
