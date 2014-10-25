//
//  ControlPanelView.h
//  Bluetooth
//
//  Created by john on 8/30/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"

@interface ControlPanelView : UIView
@property (strong,nonatomic)ASValueTrackingSlider *slider;
@property (strong,nonatomic)UIButton *toogleSwitch;
@property (strong,nonatomic)UIButton *go;
@end
