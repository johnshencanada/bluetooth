//
//  LightBulbCell.h
//  Bluetooth
//
//  Created by john on 7/1/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface LightBulbCell : UITableViewCell
@property (nonatomic) UILabel *name;
@property (nonatomic) UILabel *identifier;
@property (nonatomic) UILabel *state;
@end
