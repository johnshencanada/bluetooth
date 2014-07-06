//
//  DeviceCell.h
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SAMGradientView/SAMGradientView.h>

@interface DeviceCell : UICollectionViewCell
@property (nonatomic) UILabel *name;
@property (nonatomic) UILabel *identifier;
@property (nonatomic) UILabel *state;
@end
