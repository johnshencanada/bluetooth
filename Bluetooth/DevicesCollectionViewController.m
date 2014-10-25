//
//  DevicesCollectionViewController.m
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

//General View
#import "Dashboard.h"
#import "DevicesCollectionViewController.h"
#import "ControlPanelView.h"

// For the nextBulb
#import "LightBulbColorViewController.h"
#import "LightBulbTimerViewController.h"
#import "LightBulbRoomCollectionViewController.h"
#import "DeviceCell.h"

@interface DevicesCollectionViewController ()
//view
@property (strong,nonatomic) ControlPanelView *controlPanel;
@property (strong,nonatomic) Dashboard *dashBoard;
@property (strong,nonatomic) NSString *imageName;
//HomeKit
@property NSString *roomName;
@property (nonatomic) HMHomeManager *homeManger;
@property (nonatomic) NSMutableArray *homes;
@property (nonatomic) HMHome *primaryHome;
@property (nonatomic) HMAccessory *accessory;
//Model
@property (strong,nonatomic) CBCentralManager *centralManager;
@property (strong,nonatomic) NSNumber *rssi;
@property (strong,nonatomic) NSMutableArray *peripherals;
@property (strong,nonatomic) NSMutableArray *selectedDevices;
@end


@implementation DevicesCollectionViewController

@synthesize peripherals;
static NSString * const reuseIdentifier = @"Cell";


#pragma mark - MVC

- (instancetype)initWithName:(NSString *)name
{
    self.imageName = [NSString stringWithFormat:@"Dashboard-%@",name];
    self.roomName = name;
    [self setUpHome];
    [self setUpDevices];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(106, 106);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    layout.headerReferenceSize = CGSizeMake(0,0);
    self = [super initWithCollectionViewLayout:layout];
    
    /* check the connection every 5 seconds */
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(checkForConnectionAndConnectPeripheral)
                                   userInfo:nil
                                   repeats:YES];
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView
{
    self.dashBoard = [[Dashboard alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3)];
    [self.dashBoard setbackgroundImage:self.imageName];
    [self.dashBoard setBackImage: @"back"];
    [self.dashBoard setRefreshImage:@"reconnect"];
    [self.dashBoard setTitle:self.roomName];

    [self.dashBoard.back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventAllTouchEvents];
    [self.dashBoard.refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventAllTouchEvents];

    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height/3 - 15, 320, 400);
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[DeviceCell class] forCellWithReuseIdentifier:@"lightbulb"];
    self.dashBoard.homeLabel.text = self.roomName;

    [self.view addSubview:self.dashBoard];
    self.controlPanel = [[ControlPanelView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 70)];
    [self.view addSubview:self.controlPanel];

    [self.controlPanel.go addTarget:self action:@selector(GoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlPanel.slider addTarget:self action:@selector(adjustBrightness:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpHome
{
    self.homeManger = [[HMHomeManager alloc]init];
    self.homeManger.delegate = self;
    
    [self.homeManger addHomeWithName:@"My Home" completionHandler:^(HMHome *home, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error: %@",error);
        }
        
        /* Successful */
        else {
            NSLog(@"Created Home : %@",home.name);
        }
    }];
}

- (void)setUpDevices
{
    self.peripherals = [[NSMutableArray alloc]init];
    self.selectedDevices = [[NSMutableArray alloc]init];
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    NSLog (@"count:%d",self.peripherals.count);
}

- (void)checkForConnectionAndConnectPeripheral
{
//    for (CBPeripheral *p in self.peripherals) {
//        
//        if (p.state == CBPeripheralStateConnecting) {
//        
//        }
//            
//        if (p.state == CBPeripheralStateDisconnected) {
//            [self.centralManager connectPeripheral:p options:nil];
//            [self.collectionView reloadData];
//        }
//
//        [self.collectionView reloadData];
//
//        }
}

- (void)GoButtonTapped:(id)sender
{
    [self pushToViewControllers];
    for (Device *device in self.selectedDevices) {
        NSLog(@"I am %@",device.peripheral);
    }
}

- (void)adjustBrightness:(id)sender
{
    
}

- (void)pushToViewControllers
{
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    LightBulbColorViewController *ColorVC = [[LightBulbColorViewController alloc]initWithDevices:self.selectedDevices];
    ColorVC.extendedLayoutIncludesOpaqueBars = YES;
    LightBulbTimerViewController *TimerVC = [[LightBulbTimerViewController alloc]initWithDevices:self.selectedDevices];
    TimerVC.extendedLayoutIncludesOpaqueBars = YES;
    LightBulbRoomCollectionViewController *RoomVC = [[LightBulbRoomCollectionViewController alloc]initWithDevices:self.selectedDevices];
    RoomVC.extendedLayoutIncludesOpaqueBars = YES;
    NSArray *controllers = [NSArray arrayWithObjects: ColorVC,TimerVC,RoomVC, nil];
    tabBarController.viewControllers = controllers;
    tabBarController.tabBar.barStyle = UIBarStyleBlack;
    [tabBarController tabBar].translucent = NO;
    [self.navigationController pushViewController:tabBarController animated:NO];
}

- (void)goBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refresh
{
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.peripherals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lightbulb" forIndexPath:indexPath];
    CBPeripheral *device = [self.peripherals objectAtIndex:indexPath.row];
    if ([device.name hasPrefix:@"LEDnet"]) {
        cell.name.text = @"nextBulb";
    }
    cell.state.text = [NSString stringWithFormat:@"%ld",device.state];
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /* Find the peripheral and the cell at the index path */
    CBPeripheral *peripheral = [self.peripherals objectAtIndex:indexPath.row];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    NSLog(@"Creating new deivce");

    /* Create a device at the index path */
    Device *device = [[Device alloc]init];
    device.peripheral = peripheral;
    device.centralManager = self.centralManager;
    
    if (!device.isSelected) {
        device.isSelected = true;
        cell.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.1];
        [self.selectedDevices addObject:device];
        NSLog(@"%lu",(unsigned long)self.selectedDevices.count);
    }
    
    else {
        device.isSelected = false;
        cell.backgroundColor = [UIColor clearColor];
    }
}


#pragma mark - CBCentralManager delegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self.collectionView reloadData];
    if (central.state != CBCentralManagerStatePoweredOn) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:[NSString stringWithFormat:@"CoreBluetooth return state: %ld",central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // check the NSUserDefualts for this room
    peripheral.delegate = self;

    BOOL existing = false;
    /* check if it's already in devices list */
    for (CBPeripheral *p in self.peripherals) {
        if (p.identifier == peripheral.identifier) {
            existing = true;
        }
    }
    if (!existing) {
        [self.peripherals addObject:peripheral];
        [central connectPeripheral:peripheral options:nil];
        [self.collectionView reloadData];
        NSLog(@"Connecting %@", peripheral.name);
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.collectionView reloadData];
    [peripheral discoverServices:nil];
    NSLog(@"Discovering Services in %@", peripheral.name);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    int i = 0;
    for (;i<self.peripherals.count; i++) {
        CBPeripheral *p = [self.peripherals objectAtIndex:i];
        if (p.identifier == peripheral.identifier) {
            [self.peripherals removeObjectAtIndex:i];
        }
    }
    [self.collectionView reloadData];
}



#pragma mark - CBPeripheral delegate

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"Discovered characteristic %@", characteristic);
    }
}

/* returnRSSI is called */
//- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
//{
//    self.rssi = peripheral.RSSI;
//    if ([self.rssi intValue] > -75 && [self.rssi intValue] < -10 )
//    {
//        [self.device.peripheral writeValue:self.device.onData forCharacteristic:self.device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
//    }
//    
//    if ([self.rssi intValue] < -75 || [self.rssi intValue] > -10 )
//    {
//        [self.device.peripheral writeValue:self.device.offData forCharacteristic:self.device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
//    }
//
//    NSLog(@"The RSSI is: %@",self.rssi);
//}
//



#pragma mark - HMHomeManager delegate

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager
{
    NSLog(@"homes count:%lu",(unsigned long)self.homes.count);
}

- (void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home
{
    
}


@end
