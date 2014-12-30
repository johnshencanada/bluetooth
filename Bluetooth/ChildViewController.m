//
//  ChildViewController.m
//  nextHome
//
//  Created by john on 12/20/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "ChildViewController.h"
#import "BEMAnalogClockView.h"
#import "CHCircleGaugeView.h"

@interface ChildViewController ()
@property (nonatomic) CHCircleGaugeView *circleGaugeView;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSCalendar *calendar;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) BEMAnalogClockView *myClock;
@property (nonatomic,strong) UIDatePicker *datePicker;

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /* Title */
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 60)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
    [self.view addSubview:self.titleLabel];
   
    /* ContentView */
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(80, 60, 160, 160)];
    [self.view addSubview: self.contentView];
    
    if (self.index == 0) {
        
        self.titleLabel.text = [NSString stringWithFormat:@"Timer"];
        self.myClock = [[BEMAnalogClockView alloc] initWithFrame:self.contentView.bounds];
        
        /* Customization */
        self.myClock.realTime = YES;
        self.myClock.currentTime = YES;
        self.myClock.enableDigit = YES;
        self.myClock.digitColor = [UIColor whiteColor];
        self.myClock.digitFont = [UIFont fontWithName:@"GillSans-Light" size:17];
        self.myClock.digitOffset = 10;
        self.myClock.faceBackgroundColor = [UIColor whiteColor];
        self.myClock.faceBackgroundAlpha = 0.1;
        [self.contentView addSubview:self.myClock];
        
        self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 230, 320, 10)];
        self.datePicker.minuteInterval = 3;
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        [self.view addSubview:self.datePicker];
    }
    
    else if (self.index == 1){
        self.titleLabel.text = [NSString stringWithFormat:@"Proximity"];
        
        self.circleGaugeView = [[CHCircleGaugeView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:self.circleGaugeView];
        
        self.circleGaugeView.trackTintColor = [UIColor colorWithWhite:255 alpha:0.1];
        self.circleGaugeView.gaugeTintColor = [UIColor colorWithWhite:0 alpha:0.1];
        
        self.circleGaugeView.trackWidth = 20;
        self.circleGaugeView.gaugeWidth = 10;
        [self.circleGaugeView setValue:1 animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
