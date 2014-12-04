//
//  RoomsCollectionViewController.m
//  Bluetooth
//
//  Created by john on 8/22/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

//General View
#import "RoomsCollectionViewController.h"
#import "RoomCell.h"
#import "RoomLogoButton.h"
#import "Dashboard.h"
#import "HeaderCellView.h"
#import "DevicesCollectionViewController.h"
#import "NewRoomViewController.h"
#import "HomeViewController.h"

// For the nextBulb
#import "LightBulbColorViewController.h"
#import "LightBulbTimerViewController.h"
#import "LightBulbRoomCollectionViewController.h"

//For nextDuino
#import "nextDuinoViewController.h"

@interface RoomsCollectionViewController ()
//view
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
@property (strong,nonatomic) NSMutableArray *Devices;
@end


@implementation RoomsCollectionViewController
@synthesize peripherals;
static NSString * const reuseIdentifier = @"Room";


#pragma mark MVC
- (instancetype)init
{
    [self setUpHome];
    [self setUpDevice];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(320, 80);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.5;
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
    [self.selectedDevices removeAllObjects];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}


#pragma mark MVC helper methods

- (void)setUpDevice
{
    self.selectedDevices = [[NSMutableArray alloc]init];
    self.Devices = [[NSMutableArray alloc]init];
    self.peripherals = [[NSMutableArray alloc]init];
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
}

- (void)setUpView
{
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height/3.5, 320, 400);
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[RoomCell class] forCellWithReuseIdentifier:@"Room"];
    [self.collectionView registerClass:[HeaderCellView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    self.dashBoard = [[Dashboard alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3)];
    //    [self.dashBoard setbackgroundImage:@"Dashboard-House"];
    [self.dashBoard.home addTarget:self action:@selector(configureHome) forControlEvents:UIControlEventAllTouchEvents];
    [self.dashBoard.add addTarget:self action:@selector(newRoom) forControlEvents:UIControlEventAllTouchEvents];
    [self.view addSubview:self.dashBoard];
}

- (void)setUpHome
{
    self.homeManger = [[HMHomeManager alloc]init];
    self.homeManger.delegate = self;
    [self.homeManger addHomeWithName:@"John" completionHandler:^(HMHome *home, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        if (home == nil) {
        }
    }];
    
    /* Clear the user defaults for testing purpose */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defaults dictionaryRepresentation];
    for (id key in dict) {
        [defaults removeObjectForKey:key];
    }
    
    self.rooms =  [defaults objectForKey:@"rooms"];
    if (!self.rooms) {
        self.rooms = [[NSMutableArray alloc]init];
        [self addRoom:@"LivingRoom"];
        [self addRoom:@"Kitchen"];
        [self addRoom:@"Bedroom"];
        [self addRoom:@"Bathroom"];
        [defaults setObject:self.rooms forKey:@"rooms"];
    }
    [defaults synchronize];
}

- (void)addRoom:(NSString*)name
{
    [self.rooms addObject:name];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [defaults setObject:array forKey:name];
    [defaults synchronize];
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


- (void) configureHome
{
    UIViewController *homeVC = [[HomeViewController alloc]init];
    [self.navigationController pushViewController:homeVC animated:YES];
}


- (void)logoClicked:(RoomLogoButton*)sender
{
    NSString *roomName = [sender titleForState:UIControlStateNormal];
    NSLog(@"%@",roomName);

    [self startShake:sender];
    
    if (roomName) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *identifiers = [NSArray arrayWithArray:[defaults objectForKey:roomName]];
        
        for (NSString *identifier in identifiers) {
            for (Device *device in self.Devices) {
                if ([identifier isEqualToString:device.peripheral.identifier.UUIDString]) {
                    NSLog(@"%@",device.peripheral.identifier.UUIDString);
                    [device.peripheral writeValue:device.configurationEnabledData forCharacteristic:device.congigureCharacteristic type:CBCharacteristicWriteWithResponse];
                    
                    if (sender.isOn) {
                        [device.peripheral writeValue:device.offData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
                        sender.isOn = false;
                    }
                    
                    else {
                        [device.peripheral writeValue:device.onData forCharacteristic:device.onOffCharacteristic type:CBCharacteristicWriteWithResponse];
                        sender.isOn = true;
                    }

                }
            }
        }
    }
}

- (void)pushToNextBulbViewControllers
{
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    tabBarController.tabBar.backgroundColor = [UIColor clearColor];
    [tabBarController.tabBar setTintColor:[UIColor clearColor]];

    LightBulbColorViewController *ColorVC = [[LightBulbColorViewController alloc]initWithDevices:self.selectedDevices];
    ColorVC.extendedLayoutIncludesOpaqueBars = YES;
    LightBulbTimerViewController *TimerVC = [[LightBulbTimerViewController alloc]initWithDevices:self.selectedDevices];
    TimerVC.extendedLayoutIncludesOpaqueBars = YES;
    LightBulbRoomCollectionViewController *RoomVC = [[LightBulbRoomCollectionViewController alloc]initWithDevices:self.selectedDevices];
    RoomVC.extendedLayoutIncludesOpaqueBars = YES;
    NSArray *controllers = [NSArray arrayWithObjects: ColorVC,TimerVC,RoomVC, nil];
    tabBarController.viewControllers = controllers;
    [self.navigationController pushViewController:tabBarController animated:NO];
}

- (void)pushToNextDuinoViewControllers
{
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    nextDuinoViewController *ControlVC = [[nextDuinoViewController alloc]initWithDevices:self.selectedDevices];
    ControlVC.extendedLayoutIncludesOpaqueBars = YES;
    
    LightBulbTimerViewController *TimerVC = [[LightBulbTimerViewController alloc]initWithDevices:self.selectedDevices];
    TimerVC.extendedLayoutIncludesOpaqueBars = YES;
    LightBulbRoomCollectionViewController *RoomVC = [[LightBulbRoomCollectionViewController alloc]initWithDevices:self.selectedDevices];
    RoomVC.extendedLayoutIncludesOpaqueBars = YES;
    NSArray *controllers = [NSArray arrayWithObjects: ControlVC,TimerVC,RoomVC, nil];
    tabBarController.viewControllers = controllers;
    tabBarController.tabBar.barStyle = UIBarStyleBlack;
    [tabBarController tabBar].translucent = NO;
    [self.navigationController pushViewController:tabBarController animated:NO];
}

#pragma mark <shaking animation>

- (void) startShake:(UIView *)view
{
    CGAffineTransform normal = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform leftShake = CGAffineTransformMakeTranslation(0, -5);
    CGAffineTransform rightShake = CGAffineTransformMakeTranslation(0, 5);
    
    view.transform = leftShake;  // starting point
    
    [UIView beginAnimations:@"shake_button"context:NULL];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    view.transform = rightShake;
    view.transform = normal;  // end here & auto-reverse
    [UIView commitAnimations];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    /* Number of Room */
    if (section == 0) {
        return self.rooms.count;
    }
    
    /* Number of un-added cells */
    else {
        return self.peripherals.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Room" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        NSString *roomName = [self.rooms objectAtIndex:indexPath.row];
        cell.name.text = roomName;
        [cell setLogoImage:roomName];
        cell.logo.titleLabel.textColor = [UIColor clearColor];
        [cell.logo setTitle:roomName forState:UIControlStateNormal];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *identifiers = [defaults objectForKey:roomName];
        NSUInteger deviceCount = identifiers.count;
        [cell setStateImage:@"number-device"];
        [cell setNumberOfDevice:deviceCount];
    }
    
    else if (indexPath.section == 1) {
        CBPeripheral *device = [self.peripherals objectAtIndex:indexPath.row];
        /* Set logo Image */
        if ([device.name hasPrefix:@"LEDnet"]) {
            cell.name.text = @"nextBulb-nano";
            [cell setLogoImage:@"nextBulb-nano"];
        }
        else if ([device.name hasPrefix:@"Tint B7"]) {
            cell.name.text = @"nextBulb";
            [cell setLogoImage:@"nextBulb"];
        }
        else if ([device.name hasPrefix:@"Tint B9"]) {
            cell.name.text = @"nextBulb-mega";
            [cell setLogoImage:@"nextBulb-mega"];
        }
        else if ([device.name hasPrefix:@"Coin"]){
            cell.name.text = @"nextDuino";
            [cell setLogoImage:@"nextDuino"];
        }
        
        /* Set State Image */
        if (device.state == CBPeripheralStateConnected) {
            [cell setStateImage:@"Connected"];
        }
        else if (device.state == CBPeripheralStateConnecting)
        {
            [cell setStateImage:@"Connecting"];
        }
        else if (device.state == CBPeripheralStateDisconnected)
        {
            [cell setStateImage:@"Disconnected"];
        }
    }
    [cell.logo addTarget:self action:@selector(logoClicked:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSString *roomName = [self.rooms objectAtIndex:indexPath.row];
        DevicesCollectionViewController *deviceVC = [[DevicesCollectionViewController alloc]initWithName:roomName];
        [self.navigationController pushViewController:deviceVC animated:NO];
    }
    
    else if (indexPath.section == 1) {
        CBPeripheral *peripheral = [self.peripherals objectAtIndex:indexPath.row];
        Device *device = [[Device alloc]init];
        device.peripheral = peripheral;
        [self.selectedDevices addObject:device];
        
        if ([peripheral.name hasPrefix:@"LEDnet"]|| [peripheral.name hasPrefix:@"Tint"])
        {
            [self pushToNextBulbViewControllers];
        }
        
        else {
            [self pushToNextDuinoViewControllers];
        }
    }
}


#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 40);
}

/* Set the header and organize them into 1.Rooms 2.Uncategoried Products */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    HeaderCellView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                   UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    NSInteger sectionNumber = indexPath.section;
    if (sectionNumber == 0) {
        [headerView.category setText:@"Rooms"];
    } else if (sectionNumber == 1) {
        [headerView.category setText:@"Device"];
    }
    return headerView;
}


#pragma mark - CBCentralManager delegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self.collectionView reloadData];
    if (central.state != CBCentralManagerStatePoweredOn) {
        
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
    
    /* Check if it's already in a room */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *rooms = [defaults objectForKey:@"rooms"];
    for (NSString *room in rooms) {
        NSArray *devices = [defaults objectForKey:room];
        if (devices) {
            for (NSString *device in devices) {
                if ([device isEqualToString:peripheral.identifier.UUIDString]) {
                    existing = true;
                    NSLog(@"got here");
                }
            }
        }
    }
    
    if (!existing) {
        if ([peripheral.name hasPrefix:@"LEDnet"] || [peripheral.name hasPrefix:@"Tint"] || [peripheral.name hasPrefix:@"Coin"]) {
            Device *device = [[Device alloc]init];
            device.peripheral = peripheral;
            [self.Devices addObject:device];
            [self.peripherals addObject:peripheral];
            [central connectPeripheral:peripheral options:nil];
            [self.collectionView reloadData];
        }
    }
    
    /* Create a NSUserDefualt to store the array */
    
    /* Create a NSArray to store the rooms */

    /* Store the array in User Defaults */
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.collectionView reloadData];
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    int i = 0;
    for (;i<self.peripherals.count; i++) {
        CBPeripheral *p = [self.peripherals objectAtIndex:i];
        if (p.identifier == peripheral.identifier) {
            [self.Devices removeObjectAtIndex:i];
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
    for (Device *device in self.Devices)
    {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
                device.congigureCharacteristic = characteristic;
            }
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]]) {
                device.onOffCharacteristic = characteristic;
            }
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE4"]]) {
                device.readCharacteristic = characteristic;
            }
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE9"]]) {
                device.writeCharacteristic = characteristic;
            }
        }
    }
    
}

#pragma mark - HMHomeManager delegate


@end
