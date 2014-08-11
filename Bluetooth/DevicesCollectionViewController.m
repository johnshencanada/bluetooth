//
//  DevicesCollectionViewController.m
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "DevicesCollectionViewController.h"
#import "LightBulbDetailViewController.h"
#import "LightBulbColorViewController.h"
#import "LightBulbRoomViewController.h"

#import "LampDetailViewController.h"

#import "DeviceCell.h"

@interface DevicesCollectionViewController ()

@property (nonatomic) NSMutableArray *rooms;
@end

@implementation DevicesCollectionViewController
@synthesize devices;
static NSString * const reuseIdentifier = @"Cell";


#pragma mark - MVC

- (instancetype)init
{
    self.title = @"Janice's Home";
    self.rooms = [[NSMutableArray alloc]init];
    [self.rooms addObject:[NSString stringWithFormat:@"LivingRoom"]];
    [self.rooms addObject:[NSString stringWithFormat:@"Bedroom"]];
    [self.rooms addObject:[NSString stringWithFormat:@"Kitchen"]];

    self.devices = [[NSMutableArray alloc]init];
    self.selectedDevices = [[NSMutableArray alloc]init];

    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    NSLog (@"count:%d",devices.count);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(318, 100);
    layout.minimumInteritemSpacing = 2.0;
    layout.minimumLineSpacing = 2.0;
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
    
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0, 0, 320, 400);
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[DeviceCell class] forCellWithReuseIdentifier:@"lightbulb"];
    
    self.GoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 400, 100, 320)];
    [self.GoButton setTitle:@"Go" forState:UIControlStateNormal];
    self.GoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.GoButton];
    [self.GoButton addTarget:self action:@selector(GoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)checkForConnectionAndConnectPeripheral
{
    for (CBPeripheral *p in self.devices) {
        
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

    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    LightBulbDetailViewController *lightBulbVC = [[LightBulbDetailViewController alloc]initWithDevices:self.selectedDevices];
    LightBulbColorViewController *ColorVC = [[LightBulbColorViewController alloc]init];
    LightBulbRoomViewController *RoomVC = [[LightBulbRoomViewController alloc]init];
    NSArray *controllers = [NSArray arrayWithObjects: lightBulbVC, ColorVC,RoomVC, nil];
    tabBarController.viewControllers = controllers;
    tabBarController.tabBar.backgroundColor = [UIColor blackColor];
    [self.navigationController pushViewController:tabBarController animated:NO];

    for (Device *device in self.selectedDevices) {
        NSLog(@"I am %@",device.peripheral);
    }
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.devices.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lightbulb" forIndexPath:indexPath];
    CBPeripheral *device = [self.devices objectAtIndex:indexPath.row];
    
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

    CBPeripheral *peripheral = [self.devices objectAtIndex:indexPath.row];
    
    Device *device = [[Device alloc]init];
    device.peripheral = peripheral;
    device.centralManager = self.centralManager;

    if ([peripheral.name hasPrefix:@"LEDnet"]) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [self.selectedDevices addObject:device];
        for (Device *device in self.selectedDevices) {
            NSLog(@"I am %@",device.peripheral);
        }
        NSLog(@"%d",self.selectedDevices.count);

    }
}



//- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{



//    
//    else if ([peripheral.name isEqualToString:@"Coin"]) {
//        LampDetailViewController *lampVC = [[LampDetailViewController alloc]initWithDevice:self.device];
//        [self.navigationController pushViewController:lampVC animated:NO];
//    }
//
//}


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
    for (CBPeripheral *p in devices) {
        if (p.identifier == peripheral.identifier) {
            existing = true;
        }
    }
    if (!existing) {
        [self.devices addObject:peripheral];
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
    for (;i<devices.count; i++) {
        CBPeripheral *p = [devices objectAtIndex:i];
        if (p.identifier == peripheral.identifier) {
            [devices removeObjectAtIndex:i];
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
- (void)homeManager:(HMHomeManager *)manager didAddHome:(HMHome *)home
{
    
}


@end
