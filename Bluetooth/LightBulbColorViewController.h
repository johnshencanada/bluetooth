//
//  LightBulbColorViewController.h
//  Bluetooth
//
//  Created by john on 8/4/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISColorWheel.h"
#import "Device.h"

@interface LightBulbColorViewController : UIViewController <ISColorWheelDelegate>
{
    ISColorWheel* _colorWheel;
    UISlider* _brightnessSlider;
    UIView* _wellView;
}

@property (strong,nonatomic) NSArray *devices;

- (id) initWithDevices:(NSArray *)devices;

@end
