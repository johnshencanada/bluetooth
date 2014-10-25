//
//  RoomCell.m
//  Bluetooth
//
//  Created by john on 8/22/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "RoomCell.h"

@implementation RoomCell

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        
        self.logo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 35, 35)];
        [self.contentView addSubview:self.logo];

        self.name = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 320, 80)];
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
        self.name.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.name];
        self.numberOfDevices = 0;
        
        self.number = [[UIImageView alloc]initWithFrame:CGRectMake(250,17,50,50)];
        UIImage *logoImage = [UIImage imageNamed:@"number-deivce"];
        [self.number setImage:logoImage];
        self.number.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.number];
        
        self.numberOfDeviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(270,17,50,50)];
        self.numberOfDeviceLabel.text = [NSString stringWithFormat:@"%d", self.numberOfDevices];
        self.numberOfDeviceLabel.textColor = [UIColor whiteColor];
        self.numberOfDeviceLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];

        [self.contentView addSubview:self.numberOfDeviceLabel];
    }
    return self;
}

- (void)setLogoImage:(NSString *)logoName
{
    UIImage *logoImage;
    if ([logoName isEqualToString:@"LivingRoom"])
    {
        logoImage = [UIImage imageNamed:@"livingroom"];
    }
    else if ([logoName isEqualToString:@"Bathroom"])
    {
        logoImage = [UIImage imageNamed:@"bathroom"];
    }
    else if ([logoName isEqualToString:@"Kitchen"])
    {
        logoImage = [UIImage imageNamed:@"kitchen"];
    }
    else if ([logoName isEqualToString:@"Bedroom"])
    {
        logoImage = [UIImage imageNamed:@"bedroom"];
    }
    else if ([logoName isEqualToString:@"nextBulb-mega"])
    {
        logoImage = [UIImage imageNamed:@"nextBulb-mega"];
    }
    else if ([logoName isEqualToString:@"nextBulb-nano"])
    {
        logoImage = [UIImage imageNamed:@"nextBulb-nano"];
    }
    else if ([logoName isEqualToString:@"nextBulb"])
    {
        logoImage = [UIImage imageNamed:@"nextBulb"];
    }

    [self.logo setImage:logoImage];
    self.logo.contentMode = UIViewContentModeScaleAspectFit;

}

- (void)setStateImage:(NSString*)state
{
    UIImage *logoImage;
    if ([state isEqualToString:@"Connected"]) {
        [self.connection removeFromSuperview];
        [self.numberOfDeviceLabel removeFromSuperview];
        [self.number removeFromSuperview];
        self.connection = [[UIImageView alloc]initWithFrame:CGRectMake(250,17,50,50)];
        self.connection.contentMode = UIViewContentModeScaleAspectFit;
        logoImage = [UIImage imageNamed:@"connected"];
        self.connection.image = logoImage;
    }
    else if ([state isEqualToString:@"Connecting"]) {
        [self.connection removeFromSuperview];
        [self.numberOfDeviceLabel removeFromSuperview];
        [self.number removeFromSuperview];
        self.connection = [[UIImageView alloc]initWithFrame:CGRectMake(250,17,50,50)];
        self.connection.contentMode = UIViewContentModeScaleAspectFit;
        logoImage = [UIImage imageNamed:@"connecting"];
        self.connection.image = logoImage;
    }
    else if ([state isEqualToString:@"Disconnected"]) {
        [self.connection removeFromSuperview];
        [self.numberOfDeviceLabel removeFromSuperview];
        [self.number removeFromSuperview];
        self.connection = [[UIImageView alloc]initWithFrame:CGRectMake(250,17,50,50)];
        self.connection.contentMode = UIViewContentModeScaleAspectFit;
        logoImage = [UIImage imageNamed:@"disconnected"];
        self.connection.image = logoImage;
    }
    else {
        [self.connection removeFromSuperview];
        [self.contentView addSubview:self.numberOfDeviceLabel];
        self.connection = [[UIImageView alloc]initWithFrame:CGRectMake(250,17,50,50)];
        self.connection.contentMode = UIViewContentModeScaleAspectFit;
        logoImage = [UIImage imageNamed:@"number-device"];
        self.connection.image = logoImage;
    }
    [self.contentView addSubview:self.connection];
}

@end
