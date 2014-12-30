//
//  ClockCell.h
//  nextHome
//
//  Created by john on 12/18/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"

@interface ClockCell : UICollectionViewCell <BEMAnalogClockDelegate>
@property (strong,nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) UILabel *actionLabel;
@property (strong,nonatomic) UISwitch *enableSwitch;
@end
