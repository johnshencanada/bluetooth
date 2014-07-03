//
//  DeviceSelectorTableViewController.h
//  Bluetooth
//
//  Created by john on 7/1/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DeviceSelectorTableViewController : UITableViewController <CBCentralManagerDelegate>
@property (strong,nonatomic) CBCentralManager *centralManager;
@property (strong,nonatomic) NSMutableArray *devices;

@end
