//
//  Dashboard.h
//  nextHome
//
//  Created by john on 8/16/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Dashboard : UIView
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) NSString *homeName;
@property (nonatomic) UILabel *homeLabel;
@property (nonatomic) UILabel *state;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *AMPMLabel;
@property (nonatomic) UILabel *dateLabel;

@property (nonatomic) UIButton *home;
@property (nonatomic) UIButton *camera;
@property (nonatomic) UIButton *back;
@property (nonatomic) UIButton *refresh;

- (void)setTitle:(NSString *)title;
- (void)setbackgroundImage:(NSString *)image;
- (void)setBackImage:(NSString *)imageName;
- (void)setRefreshImage:(NSString *)imageName;
@end
