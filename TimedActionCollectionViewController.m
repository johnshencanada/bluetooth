//
//  TimedActionCollectionViewController.m
//  nextHome
//
//  Created by john on 12/18/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "TimedActionCollectionViewController.h"
#import "NewActionViewController.h"
#import "ClockCell.h"
#import "VBFPopFlatButton.h"

@interface TimedActionCollectionViewController ()
@property NSMutableArray *clocks;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *back;
@property (strong,nonatomic) VBFPopFlatButton *flatRoundedButton;
@property (strong,nonatomic) NSArray *actions;
@end

@implementation TimedActionCollectionViewController

static NSString * const reuseIdentifier = @"Clock";

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.devices = [NSArray arrayWithArray:devices];
        UIImage *timer = [UIImage imageNamed:@"alarm-small"];
        UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"Timer" image:timer tag:0];
        self.tabBarItem = homeTab;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(320, 130);
        layout.minimumInteritemSpacing = 2.0;
        layout.minimumLineSpacing = 1.0;
        layout.headerReferenceSize = CGSizeMake(0,0);
        self = [super initWithCollectionViewLayout:layout];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.actions = [defaults objectForKey:@"actions"];
    
    if (self.actions) {
        [self.collectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpView
{
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height/3 - 15, 320, 350);
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[ClockCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    /* set up image view */
    UIImage *image = [UIImage imageNamed:@"back"];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(20, 25, 30, 30)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.back];
    [self.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventAllTouchEvents];
    
    /* Do any additional setup after loading the view */
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 60)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
    self.titleLabel.text = [NSString stringWithFormat:@"Add Action"];
    [self.view addSubview:self.titleLabel];
    
    [self setupAddButton];
}

- (void)setupAddButton
{
    self.flatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(130, 80, 60, 60)
                                                         buttonType:buttonAddType
                                                        buttonStyle:buttonRoundedStyle
                                              animateToInitialState:YES];
    
    self.flatRoundedButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.flatRoundedButton.lineThickness = 2;
    self.flatRoundedButton.tintColor = [UIColor colorWithWhite:255 alpha:0.6];
    [self.flatRoundedButton addTarget:self
                               action:@selector(createNewAction)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flatRoundedButton];
}

- (void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createNewAction
{
    NewActionViewController *newAcitonVC = [[NewActionViewController alloc]initWithDevices:self.devices];
    [self.navigationController pushViewController:newAcitonVC animated:NO];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *timedActionArray = [NSMutableArray arrayWithArray:[defaults objectForKey:@"actions"]];
    return [timedActionArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ClockCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (self.actions) {
        NSDictionary *dictionary = [self.actions objectAtIndex:indexPath.row];
        NSNumber *actionType = [dictionary objectForKey:@"actionType"];
        NSNumber *onOff = [dictionary objectForKey:@"OnOff"];

        if ([actionType intValue] == 0) {
            NSDate *date = [dictionary objectForKey:@"time"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"hh:mm a"];
            NSString *dateString = [dateFormatter stringFromDate:date];
            cell.timeLabel.text = dateString;
        }
        
        else {
//            NSNumber *proximity = [dictionary objectForKey:@"proximity"];
            NSLog(@"shit");
        }

        
        if ([onOff intValue] == 1) {
            cell.actionLabel.text = @"On";
        }
        
        else {
            cell.actionLabel.text = @"Off";
        }
    }
    
    // Configure the cell
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClockCell *cell = (ClockCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self startShake:cell.timeLabel];
}

#pragma mark <Shaking animation>

- (void) startShake:(UIView *)view
{
    CGAffineTransform normal = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform leftShake = CGAffineTransformMakeTranslation(-5, 0);
    CGAffineTransform rightShake = CGAffineTransformMakeTranslation(5, 0);
    
    view.transform = leftShake;  // starting point
    
    [UIView beginAnimations:@"shake_button"context:NULL];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:1000];
    [UIView setAnimationDuration:0.02];
    [UIView setAnimationDelegate:self];
    view.transform = rightShake;
    view.transform = normal;  // end here & auto-reverse
    [UIView commitAnimations];
}

@end
