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
#import "NYSegmentedControl.h"
#import "VBFPopFlatButton.h"

@interface ChildViewController ()

//view
@property (nonatomic) CHCircleGaugeView *circleGaugeView;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSCalendar *calendar;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) BEMAnalogClockView *myClock;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) NYSegmentedControl *foursquareSegmentedControl;
@property (nonatomic,strong) UIButton *goButton;
@property (nonatomic,strong) UILabel *proximityLabel;
//clock
@property (nonatomic,strong) NSString *dateString;
@property BOOL turnOn;

//proximity
@property (strong,nonatomic) NSNumber *rssi;
@property int rssiVal;
@property int averageRSSI;
@property int proximity;
@property double percentage;

//model
@property (nonatomic,strong)NSMutableArray *actionArray;
@property (nonatomic,strong)NSDictionary *dictionary;
@end

@implementation ChildViewController

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.devices = [NSArray arrayWithArray:devices];
        for (Device *device in devices) {
            device.peripheral.delegate = self;
        }
    }
    return self;
}

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
        [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.datePicker];
    }
    
    else if (self.index == 1) {
        self.titleLabel.text = [NSString stringWithFormat:@"Proximity"];
        
        self.circleGaugeView = [[CHCircleGaugeView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:self.circleGaugeView];
        
        self.circleGaugeView.trackTintColor = [UIColor colorWithWhite:255 alpha:0.1];
        self.circleGaugeView.gaugeTintColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.circleGaugeView.textColor = [UIColor lightGrayColor];
        self.circleGaugeView.trackWidth = 20;
        self.circleGaugeView.gaugeWidth = 10;
        [self.circleGaugeView setValue:0 animated:YES];
        
        self.proximityLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 250, 160, 60)];
        self.proximityLabel.textColor = [UIColor lightGrayColor];
        self.proximityLabel.textAlignment = NSTextAlignmentCenter;
        self.proximityLabel.text = @"Too Far Nigger!";
        self.proximityLabel.font = [UIFont fontWithName:@"GillSans-Light" size:25];
        [self.view addSubview:self.proximityLabel];
    }
    
    self.proximity = 100;
    self.date = [NSDate date];
    [self setupSegementedControl];
    [self setupGoButton];
    
    /* check the connection every 1 second */
    if ([self.devices count]) {
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                          target:self
                                        selector:@selector(checkRSSI)
                                        userInfo:nil
                                         repeats:YES];
    }
}

- (void)setupSegementedControl
{
    self.turnOn = true;
    UIView *foursquareSegmentedControlBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                                0.0f,
                                                                                                CGRectGetWidth([UIScreen mainScreen].bounds),
                                                                                                44.0f)];
    foursquareSegmentedControlBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:foursquareSegmentedControlBackgroundView];
    
    self.foursquareSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"On", @"Off"]];
    self.foursquareSegmentedControl.titleTextColor = [UIColor lightGrayColor];
    self.foursquareSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    self.foursquareSegmentedControl.selectedTitleFont = [UIFont systemFontOfSize:13.0f];
    self.foursquareSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:0.6];
    self.foursquareSegmentedControl.backgroundColor = [UIColor colorWithRed:0.31f green:0.53f blue:0.72f alpha:0.2f];
    self.foursquareSegmentedControl.borderWidth = 0.0f;
    self.foursquareSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    self.foursquareSegmentedControl.segmentIndicatorInset = 1.0f;
    self.foursquareSegmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
    [self.foursquareSegmentedControl sizeToFit];
    self.foursquareSegmentedControl.cornerRadius = CGRectGetHeight(self.foursquareSegmentedControl.frame) / 2.0f;
    self.foursquareSegmentedControl.center = CGPointMake(self.view.center.x, self.view.center.y + 170.0f);
    foursquareSegmentedControlBackgroundView.center = self.foursquareSegmentedControl.center;
    [self.foursquareSegmentedControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.foursquareSegmentedControl];
}

- (void)setupGoButton
{
    self.goButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 600, 320, 80)];
    [self.goButton setTitle: @"Set!" forState:UIControlStateNormal];
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.goButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.goButton.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:50.0];
    self.goButton.backgroundColor = [UIColor colorWithWhite:255 alpha:0.2];
    [self.goButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self pushUpGoButton];
}

- (void)pushUpGoButton
{
    [self.view addSubview:self.goButton];
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:13
                        options:0
                     animations:^() {
                         self.goButton.center = CGPointMake(160, 530);
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark -  Delegate

- (void)checkRSSI
{
    self.rssiVal = 0;
    self.averageRSSI = 0;
    int deviceCount = 0;
    
    for (Device *device in self.devices) {
        
        CBPeripheral *peripheral = device.peripheral;
        if (peripheral) {
            deviceCount++;
            [peripheral readRSSI];
        }
    }
}

- (void)segmentSelected:(NYSegmentedControl*)foursquareSegmentedControl
{
    int index = (int)foursquareSegmentedControl.selectedSegmentIndex;
    
    if (index == 0)
    {
        self.turnOn = true;
    }
    
    else if (index == 1)
    {
        self.turnOn = false;
    }
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    self.date = datePicker.date;
    self.dateString = [dateFormatter stringFromDate:self.date];
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.actionArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"actions"]];
    
    if (!self.actionArray) {
        self.actionArray = [[NSMutableArray alloc]init];
    }
    
    NSString * key1 = @"actionType";    // 0 as time triggered action; 1 as proximity triggered action
    NSString * key2 = @"OnOff";         // on or off
    NSString * key3 = @"time";          // the time of the action
    NSString * key4 = @"proximity";     // proximity number from 0 - 100
    
    NSNumber *obj1 = [NSNumber numberWithLong:self.index];
    NSNumber *obj2 = [NSNumber numberWithBool:self.turnOn];
    NSDate *obj3 = self.date;
    NSNumber *obj4 = [NSNumber numberWithInt:self.proximity];
    NSDictionary * dictionary =[NSDictionary dictionaryWithObjects:@[obj1,obj2,obj3,obj4] forKeys:@[key1,key2,key3,key4]];

    [self.actionArray addObject:dictionary];
    [defaults setObject:self.actionArray forKey:@"actions"];
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (double)ConvertRSSItoPercentage {
    int absoluteRSSI = abs(self.averageRSSI);
    absoluteRSSI -= 40;
    absoluteRSSI = 60 - absoluteRSSI;
    double percentageRSSI = absoluteRSSI * 0.016666667;
    
    NSLog(@"%lf",percentageRSSI);
    
    if (absoluteRSSI >= 100) {
        return 1.0;
    }
    
    else if (absoluteRSSI < 100) {
        self.proximityLabel.text = @"Still Far Man!";
    }
    
    else if (absoluteRSSI >= 90 && absoluteRSSI < 100) {
        self.proximityLabel.text = @"Quite Distant!";
    }
    
    else if (absoluteRSSI >= 80 && absoluteRSSI < 90) {
        self.proximityLabel.text = @"Getting There";
    }
    
    else if (absoluteRSSI >= 75 && absoluteRSSI < 80) {
        self.proximityLabel.text = @"Getting Close";
    }
    
    else if (absoluteRSSI >= 70 && absoluteRSSI < 75) {
        self.proximityLabel.text = @"Pretty Close";
    }
    
    else if (absoluteRSSI < 70) {
        self.proximityLabel.text = @"In Your Face MotherFuker!";
    }
    
    return percentageRSSI;

}

#pragma mark - CBPeripheral delegate

/* returnRSSI is called */
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.rssiVal += [peripheral.RSSI intValue];
    
    if (self.rssiVal) {
        int devceCount = (int)[self.devices count];
        self.averageRSSI += [peripheral.RSSI intValue]/devceCount;
        self.proximity = self.rssiVal;
    }
    
    NSLog(@"The RSSI is: %d",self.averageRSSI);
    
    self.percentage = [self ConvertRSSItoPercentage];
    [self.circleGaugeView setValue:(self.percentage) animated:YES];
}

@end
