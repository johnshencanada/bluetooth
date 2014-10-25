//
//  LightBulbRoomCollectionViewController.m
//  Bluetooth
//
//  Created by john on 9/16/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "LightBulbRoomCollectionViewController.h"
#import "RoomCell.h"
#import "RoomPictureCell.h"
#import "Device.h"

@interface LightBulbRoomCollectionViewController ()
@property (nonatomic) NSArray *rooms;
@property (nonatomic) NSString *currentRoom;
@end

@implementation LightBulbRoomCollectionViewController

static NSString * const reuseIdentifier = @"Room";

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        
        self.devices = [NSArray arrayWithArray:devices];

        UIImage *home = [UIImage imageNamed:@"home"];
        UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"Home" image:home tag:0];
        self.tabBarItem = homeTab;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(320, 150);
        layout.minimumInteritemSpacing = 1.0;
        layout.minimumLineSpacing = 1.0;
        layout.headerReferenceSize = CGSizeMake(0,0);
        self = [super initWithCollectionViewLayout:layout];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.rooms = [defaults objectForKey:@"rooms"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}

- (void)setUpView
{
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height/3 - 15, 320, 350);
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[RoomPictureCell class] forCellWithReuseIdentifier:@"Room"];
}

- (void)checkCurrentRoom
{
    /* Check which room this device is currently in */
    for (Device *device in self.devices)
    {
        for (NSString *room in self.rooms) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *identifiers = [NSArray arrayWithArray:[defaults objectForKey:room]];
            NSLog(@"There are %d objects in %@",identifiers.count,room);

            for (NSString *identifier in identifiers) {
                NSLog(@"%@ VS %@",identifier,device.peripheral.identifier.UUIDString);

                if ([identifier isEqualToString:device.peripheral.identifier.UUIDString]) {
                    NSLog(@"GOT IT");
                    self.currentRoom = room;
                }
            }
        }
    }
    
}

- (void)PrintRoomDevices
{
    for (NSString *room in self.rooms) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *identifiers = [NSArray arrayWithArray:[defaults objectForKey:room]];
        NSLog(@"There are %d objects in %@",identifiers.count,room);
    }

}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.rooms.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RoomPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Room" forIndexPath:indexPath];
    NSString *roomName = [self.rooms objectAtIndex:indexPath.row];
    [cell setLabelName:roomName];
    [cell setImage:[NSString stringWithFormat:@"Dashboard-%@",roomName]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self checkCurrentRoom];
    
    RoomPictureCell *cell = (RoomPictureCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *roomName = [self.rooms objectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSLog(@"current room is: %@",self.currentRoom);
    /* If this peripheral don't belong to any room */
    if (!self.currentRoom) {
        NSLog(@"Not in any room");
        
        /* Make it belong to this room */
        [cell setIsSelected];
        /* Save it into data */
        NSMutableArray *devicesUUID = [NSMutableArray arrayWithArray:[defaults objectForKey:roomName]];
        for (Device *device in self.devices) {
            [devicesUUID addObject:device.peripheral.identifier.UUIDString];
        }
        
        /* Remove that saved array and update it */
        NSLog(@"Updating %@",roomName);
        [defaults setObject:[NSArray arrayWithArray:devicesUUID] forKey:roomName];
        [self PrintRoomDevices];
    }
    
    /* Or it belongs to a room */
    else {

        NSLog(@"Currently in:%@",self.currentRoom);

        /* If the user select the same room */
        if ([roomName isEqualToString:self.currentRoom]) {
            
            /* if it's already selected, diselect it */
            if (cell.isSelected) {
                [cell setUnSelected];
                self.currentRoom = NULL;
                NSLog(@"current room is: %@",self.currentRoom);
                
                /* Remove the device in this room saved in data */
                for (Device *device in self.devices)
                {
                    NSMutableArray *identifiers = [NSMutableArray arrayWithArray:[defaults objectForKey:roomName]];
                    
                    for (NSString *identifier in identifiers) {
                        
                        if ([identifier isEqualToString:device.peripheral.identifier.UUIDString]) {
                            NSLog(@"Got it, I have to remove it now!");
                            [identifiers removeObject:identifier];
                            [defaults setObject:[NSArray arrayWithArray:identifiers] forKey:roomName];
                            [defaults synchronize];
                        }
                    }
                }
            }
        }
        
        /* If the user selects another room */
        else {
            NSLog(@"else");
            
            /* Remove the devices from its previous room */
            for (Device *device in self.devices)
            {
                NSMutableArray *identifiers = [NSMutableArray arrayWithArray:[defaults objectForKey:self.currentRoom]];
                for (NSString *identifier in identifiers) {
                    if ([identifier isEqualToString:device.peripheral.identifier.UUIDString]) {
                        NSLog(@"Got it, I have to remove it now!");
                        [identifiers removeObject:identifier];
                        [defaults setObject:[NSArray arrayWithArray:identifiers] forKey:roomName];
                        [defaults synchronize];
                    }
                }
            }
            /* Select this room */
        }
    }
    
    [defaults synchronize];

    
    for (Device *device in self.devices) {
        NSLog(@"Identifier: %@",device.peripheral.identifier);
    }
}


@end
