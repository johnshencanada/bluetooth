//
//  DevicesCollectionViewController.h
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DevicesCollectionViewController : UICollectionViewController <CBCentralManagerDelegate,CBPeripheralDelegate>
@property (strong,nonatomic) CBCentralManager *centralManager;
@property (strong,nonatomic) NSMutableArray *devices;

@end
