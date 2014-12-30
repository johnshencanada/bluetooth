//
//  RoomCell.h
//  nextHome
//
//  Created by john on 8/22/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleCounter.h"
#import "RoomLogoButton.h"

@interface RoomCell : UICollectionViewCell
@property (nonatomic) RoomLogoButton *logo;
@property (nonatomic) UILabel *name;
@property (nonatomic) UIImageView *numberOfDeviceImage;
@property (nonatomic) UILabel *numberOfDeviceLabel;
@property (nonatomic) UIImageView *connection;
@property int numberOfDevices;

- (void)setLogoImage:(NSString*)logoName;
- (void)setStateImage:(NSString*)state;
-(void)setNumberOfDevice:(NSUInteger)number;

@end
