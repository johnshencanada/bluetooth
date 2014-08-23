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

// For the nextBulb
#import "LightBulbDetailViewController.h"
#import "LightBulbColorViewController.h"
#import "LightBulbRoomViewController.h"
#import "DeviceCell.h"

//For nextLamp
#import "LampDetailViewController.h"

@interface DevicesCollectionViewController ()
//view
@property (strong,nonatomic) UIButton *GoButton;
@property (strong,nonatomic) Dashboard *dashBoard;
//HomeKit
@property (nonatomic) HMHomeManager *homeManger;
@property (nonatomic) NSMutableArray *homes;
@property (nonatomic) HMHome *primaryHome;
@property (nonatomic) NSMutableArray *rooms;
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
#define screenWidth = self.view.frame.size.height/2)

- (instancetype)init
{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void) setUpView
{
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height/3 - 15, 320, 400);
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[DeviceCell class] forCellWithReuseIdentifier:@"lightbulb"];
    
    self.dashBoard = [[Dashboard alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3)];

    [self.view addSubview:self.dashBoard];
    
    self.GoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-25, self.view.frame.size.width, 50)];
    self.GoButton.backgroundColor = [UIColor blackColor];
    [self.GoButton setTitle:@"Go" forState:UIControlStateNormal];
    self.GoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.GoButton];
    [self.GoButton addTarget:self action:@selector(GoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setUpHome
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
    
    self.rooms = [[NSMutableArray alloc]init];
    [self.rooms addObject:[NSString stringWithFormat:@"LivingRoom"]];
    [self.rooms addObject:[NSString stringWithFormat:@"Bedroom"]];
    [self.rooms addObject:[NSString stringWithFormat:@"Kitchen"]];
}

- (void) setUpDevices
{
    self.peripherals = [[NSMutableArray alloc]init];
    self.selectedDevices = [[NSMutableArray alloc]init];
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    NSLog (@"count:%d",self.peripherals.count);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)checkForConnectionAndConnectPeripheral
{
    for (CBPeripheral *p in self.peripherals) {
        
        if (p.state == CBPeripheralStateConnecting) {
        
        }
            
        if (p.state == CBPeripheralStateDisconnected) {
            [self.centralManager connectPeripheral:p options:nil];
            [self.collectionView reloadData];
        }
            
        [self.collectionView reloadData];

        }
}

- (void) GoButtonTapped:(id)sender
{
    [self pushToViewControllers];
    for (Device *device in self.selectedDevices) {
        NSLog(@"I am %@",device.peripheral);
    }
}

- (void) pushToViewControllers
{
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    LightBulbDetailViewController *lightBulbVC = [[LightBulbDetailViewController alloc]initWithDevices:self.selectedDevices];
    LightBulbColorViewController *ColorVC = [[LightBulbColorViewController alloc]initWithDevices:self.selectedDevices];
    LightBulbRoomViewController *RoomVC = [[LightBulbRoomViewController alloc]initWithDevices:self.selectedDevices];
    NSArray *controllers = [NSArray arrayWithObjects: lightBulbVC, ColorVC,RoomVC, nil];
    tabBarController.viewControllers = controllers;
    tabBarController.tabBar.backgroundColor = [UIColor blackColor];
    [self.navigationController pushViewController:tabBarController animated:NO];
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
    cell.room.text = [NSString stringWithFormat:@"My Room"];
    if ([device.name hasPrefix:@"LEDnet"]) {
        cell.name.text = [NSString stringWithFormat:@"BananaBulb"];
    }
    cell.state.text = [NSString stringWithFormat:@"%d",device.state];

    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    /*Find the peripheral and the cell at the index path */
    CBPeripheral *peripheral = [self.peripherals objectAtIndex:indexPath.row];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    NSLog(@"Creating new deivce");

    /* Create a device at the index path */
    Device *device = [[Device alloc]init];
    device.peripheral = peripheral;
    device.centralManager = self.centralManager;
    
    
    if (!device.isSelected) {
        device.isSelected = true;
        cell.backgroundColor = [UIColor whiteColor];
        [self.selectedDevices addObject:device];
        NSLog(@"%d",self.selectedDevices.count);
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
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops" message:[NSString stringWithFormat:@"CoreBluetooth return state: %d",central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
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

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self.collectionView reloadData];
    
    if ([peripheral.name isEqual:@"Coin"]) {
        [peripheral discoverServices:@[[CBUUID UUIDWithString:kCNCoinBLEServiceUUID]]];
    } else {
        [peripheral discoverServices:nil];
    }
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
    self.homes = manager.homes;
    self.primaryHome = manager.primaryHome;
    NSLog(@"homes count:%d",self.homes.count);
}

- (void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home
{
    
}


@end
