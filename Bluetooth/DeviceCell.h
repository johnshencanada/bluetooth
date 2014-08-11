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
@property (nonatomic) UILabel *room;
@property (nonatomic) UILabel *name;
@property (nonatomic) UILabel *state;
@property (nonatomic) UIButton *profilePicture;
@end
