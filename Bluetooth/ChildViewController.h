//
//  ChildViewController.h
//  nextHome
//
//  Created by john on 12/20/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"

@interface ChildViewController : UIViewController <BEMAnalogClockDelegate, UIGestureRecognizerDelegate>
@property (assign, nonatomic) NSInteger index;


@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *contentView;

@end
