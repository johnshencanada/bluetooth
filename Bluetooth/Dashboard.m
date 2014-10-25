//
//  Dashboard.m
//  Bluetooth
//
//  Created by john on 8/16/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "Dashboard.h"

@implementation Dashboard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.backgroundImageView];
        [self setbackgroundImage:@"Dashboard-House"];
        
        UIImage *homeButtonImage = [UIImage imageNamed:@"home"];
        self.home = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 30, 30)];
        [self.home setBackgroundImage:homeButtonImage forState:UIControlStateNormal];
        [self addSubview:self.home];
        
        UIImage *addButtonImage = [UIImage imageNamed:@"add"];
        self.add = [[UIButton alloc]initWithFrame:CGRectMake(270, 20, 30, 30)];
        [self.add setBackgroundImage:addButtonImage forState:UIControlStateNormal];
        [self addSubview:self.add];
        
        self.homeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 320, 20)];
        self.homeLabel.text = [NSString stringWithFormat:@"nextHome"];
        self.homeLabel.textAlignment = NSTextAlignmentCenter;
        self.homeLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
        self.homeLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.homeLabel];
        
        /* Add some shawdow to it*/
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowPath = shadowPath.CGPath;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [self.homeLabel setText:[NSString stringWithFormat:@"%@",title]];
}

- (void)setbackgroundImage:(NSString *)imageName
{
    /* Black gradient */
    UIImage *image = [UIImage imageNamed:imageName];
    self.backgroundImageView.image = image;
    
    CGRect barRect1 = CGRectMake(0.0f, 0.0f, 320.0f, 48.0f);
    barRect1.size.width *= [self.backgroundImageView.image scale];
    barRect1.size.height *= [self.backgroundImageView.image scale];
    CGImageRef imageRef1 = CGImageCreateWithImageInRect([self.backgroundImageView.image CGImage], barRect1);
    UIImage *topImage1 = [UIImage imageWithCGImage:imageRef1
                                            scale:[self.backgroundImageView.image scale]
                                      orientation:UIImageOrientationUp];
    CGImageRelease(imageRef1);
    /* Gradient View */
    UIColor *colorOne = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95];
    UIColor *colorTwo = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    NSArray *colors = [NSArray arrayWithObjects: (id)colorOne.CGColor,
                                                 (id)colorTwo.CGColor,
                                                                    nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0f];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0f];
    
    NSArray *locations1 = [NSArray arrayWithObjects:stopOne,stopTwo,nil];

    CAGradientLayer *alphaGradientLayer1 = [CAGradientLayer layer];
    [alphaGradientLayer1 setColors:colors];
    [alphaGradientLayer1 setLocations:locations1];
    
    UIImageView *view1 = [[UIImageView alloc] initWithImage:topImage1];
    [alphaGradientLayer1 setFrame:[view1 bounds]];
    [[view1 layer] insertSublayer:alphaGradientLayer1 atIndex:0];
    [self addSubview:view1];

}

- (void)setBackImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 25, 25)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.home removeFromSuperview];
    [self addSubview:self.back];
}

- (void)setRefreshImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    self.refresh = [[UIButton alloc]initWithFrame:CGRectMake(280, 20, 25, 25)];
    [self.refresh setBackgroundImage:image forState:UIControlStateNormal];
    [self addSubview:self.refresh];
    [self.add removeFromSuperview];
}

@end
