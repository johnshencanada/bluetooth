//
//  NewActionViewController.m
//  nextHome
//
//  Created by john on 12/20/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "NewActionViewController.h"
#import "ChildViewController.h"
#import "VBFPopFlatButton.h"
#import "NYSegmentedControl.h"

@interface NewActionViewController ()
@property (nonatomic) UIButton *back;
@property (strong,nonatomic) VBFPopFlatButton *backwardButton;
@property (strong,nonatomic) VBFPopFlatButton *forwardButton;
@property (nonatomic,strong) UIButton *goButton;

@end

@implementation NewActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];

    /* Create new PageViewController */
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    [[self.pageViewController view]setFrame:CGRectMake(0, 0, 320, 420)];
    
    ChildViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:_pageViewController];
    [[self view] addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}



- (void)setUpView
{
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor clearColor];
    pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
    
    /* set up image view */
    UIImage *image = [UIImage imageNamed:@"back"];
    self.back = [[UIButton alloc]initWithFrame:CGRectMake(20, 25, 30, 30)];
    [self.back setBackgroundImage:image forState:UIControlStateNormal];
    [self.view addSubview:self.back];
    [self.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventAllTouchEvents];
    
    self.backwardButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(80, 15, 40, 40)
                                                         buttonType:buttonBackType
                                                        buttonStyle:buttonPlainStyle
                                              animateToInitialState:YES];
    self.backwardButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.backwardButton.lineThickness = 2;
    self.backwardButton.tintColor = [UIColor colorWithWhite:255 alpha:0.6];
    [self.backwardButton addTarget:self
                               action:@selector(goBack)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backwardButton];

    self.forwardButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(200, 15, 40, 40)
                                                      buttonType:buttonForwardType
                                                     buttonStyle:buttonPlainStyle
                                           animateToInitialState:YES];
    self.forwardButton.roundBackgroundColor = [UIColor colorWithWhite:255 alpha:0.1];
    self.forwardButton.lineThickness = 2;
    self.forwardButton.tintColor = [UIColor colorWithWhite:255 alpha:0.6];
    [self.forwardButton addTarget:self
                            action:@selector(goForward)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forwardButton];
    
    [self setupSegementedControl];
    [self setupGoButton];
}

- (void)setupSegementedControl
{
    UIView *foursquareSegmentedControlBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                                0.0f,
                                                                                                CGRectGetWidth([UIScreen mainScreen].bounds),
                                                                                                44.0f)];
    foursquareSegmentedControlBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:foursquareSegmentedControlBackgroundView];
    
    NYSegmentedControl *foursquareSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"On", @"Off"]];
    foursquareSegmentedControl.titleTextColor = [UIColor lightGrayColor];
    foursquareSegmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    foursquareSegmentedControl.selectedTitleFont = [UIFont systemFontOfSize:13.0f];
    foursquareSegmentedControl.segmentIndicatorBackgroundColor = [UIColor colorWithRed:0.38f green:0.68f blue:0.93f alpha:0.6];
    foursquareSegmentedControl.backgroundColor = [UIColor colorWithRed:0.31f green:0.53f blue:0.72f alpha:0.2f];
    foursquareSegmentedControl.borderWidth = 0.0f;
    foursquareSegmentedControl.segmentIndicatorBorderWidth = 0.0f;
    foursquareSegmentedControl.segmentIndicatorInset = 1.0f;
    foursquareSegmentedControl.segmentIndicatorBorderColor = self.view.backgroundColor;
    [foursquareSegmentedControl sizeToFit];
    foursquareSegmentedControl.cornerRadius = CGRectGetHeight(foursquareSegmentedControl.frame) / 2.0f;
    foursquareSegmentedControl.center = CGPointMake(self.view.center.x, self.view.center.y + 150.0f);
    foursquareSegmentedControlBackgroundView.center = foursquareSegmentedControl.center;
    [self.view addSubview:foursquareSegmentedControl];
}

- (void)setupGoButton
{
    self.goButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 600, 320, 80)];
    [self.goButton setTitle: @"Go!" forState:UIControlStateNormal];
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.goButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.goButton.titleLabel.font = [UIFont fontWithName:@"GillSans-Light" size:50.0];
    self.goButton.backgroundColor = [UIColor colorWithWhite:255 alpha:0.2];
    [self.goButton addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
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


#pragma mark - UIbuttons Delegate

- (void)go
{
    
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)backward
{
    
}

- (void)forward
{
//    [self.pageViewController setViewControllers:direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (ChildViewController *)viewControllerAtIndex:(NSUInteger)index
{
    ChildViewController *childViewController = [[ChildViewController alloc]init];
    childViewController.index = index;
    return childViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(ChildViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    
    index --;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(ChildViewController *)viewController index];
    index++;
    
    if (index == 2) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
