//
//  DevicesCollectionViewController.m
//  Bluetooth
//
//  Created by john on 7/3/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "DevicesCollectionViewController.h"
#import "LightBulbDetailViewController.h"
#import "LampDetailViewController.h"

#import "DeviceCell.h"
#import "Device.h"

@interface DevicesCollectionViewController ()

@end


@implementation DevicesCollectionViewController
@synthesize devices;
static NSString * const reuseIdentifier = @"Cell";


#pragma mark - MVC

- (instancetype)init
{
    self.devices = [[NSMutableArray alloc]init];
    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    NSLog (@"count:%d",devices.count);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(318, 100);
    layout.minimumInteritemSpacing = 2.0;
    layout.minimumLineSpacing = 2.0;
    self = [super initWithCollectionViewLayout:layout];
    
    /* chekc the connection every 5 seconds */
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
    self.navigationController.
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[DeviceCell class] forCellWithReuseIdentifier:@"lightbulb"];
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
    cell.name.text = device.name;
    cell.identifier.text = [NSString stringWithFormat:@"%@",[device.identifier UUIDString]];
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
    
    if ([peripheral.name isEqualToString:@"Coin"]) {
        LampDetailViewController *lampVC = [[LampDetailViewController alloc]initWithDevice:device];
        [self.navigationController pushViewController:lampVC animated:NO];

    } else if ([peripheral.name hasPrefix:@"LEDnet"]) {
        
        LightBulbDetailViewController *lightBulbVC = [[LightBulbDetailViewController alloc]initWithDevice:device];
        [self.navigationController pushViewController:lightBulbVC animated:NO];
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
//    NSLog(@"Peripheral Disconnected");
//    int i = 0;
//    for (;i<devices.count; i++) {
//        CBPeripheral *p = [devices objectAtIndex:i];
//        if (p.identifier == peripheral.identifier) {
//            [devices removeObjectAtIndex:i];
//        }
//    }
    [self.collectionView reloadData];

}

#pragma  mark - CBPeripheral delegate

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


@end
