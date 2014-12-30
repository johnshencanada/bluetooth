//
//  LightBulbRoomCollectionViewController.m
//  nextHome
//
//  Created by john on 9/16/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "LightBulbRoomCollectionViewController.h"
#import "RoomCell.h"
#import "RoomPictureCell.h"
#import "Device.h"
#import "VBFPopFlatButton.h"

@interface LightBulbRoomCollectionViewController ()
@property (nonatomic) NSArray *rooms;
@property (nonatomic) NSString *currentRoom;
@property (nonatomic) UILabel *currentRoomLabel;
@property (strong,nonatomic) VBFPopFlatButton *flatRoundedButton;
@end

@implementation LightBulbRoomCollectionViewController

static NSString * const reuseIdentifier = @"Room";

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        
        self.devices = [NSArray arrayWithArray:devices];
        
        UIImage *home = [UIImage imageNamed:@"home_small"];
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
    [self checkCurrentRoom];
}

- (void)setUpView
{
    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height/3 - 15, 320, 350);
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[RoomPictureCell class] forCellWithReuseIdentifier:@"Room"];
    
    self.currentRoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 60)];
    self.currentRoomLabel.textColor = [UIColor whiteColor];
    self.currentRoomLabel.textAlignment = NSTextAlignmentCenter;
    self.currentRoomLabel.font = [UIFont fontWithName:@"GillSans-Light" size:20.0];
    self.currentRoomLabel.text = [NSString stringWithFormat:@"Please Select Room"];
    [self.view addSubview:self.currentRoomLabel];
    
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
                               action:@selector(flatRoundedButtonPressed)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flatRoundedButton];
}

- (void)checkCurrentRoom
{
    /* Check which room this device is currently in */
    for (Device *device in self.devices)
    {
        for (NSString *room in self.rooms) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *identifiers = [NSArray arrayWithArray:[defaults objectForKey:room]];

            for (NSString *identifier in identifiers) {

                if ([identifier isEqualToString:device.peripheral.identifier.UUIDString]) {
                    NSLog(@"GOT IT");
                    self.currentRoom = room;
                    self.currentRoomLabel.text = self.currentRoom;
                }
            }
        }
    }
    
}

- (void)PrintRoomDevices
{
    for (NSString *room in self.rooms) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (room) {
            NSArray *identifiers = [NSArray arrayWithArray:[defaults objectForKey:room]];
            NSLog(@"There are %lu objects in %@",(unsigned long)identifiers.count,room);
        }
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
    for (Device *device in self.devices) {
        NSLog(@"Identifier: %@",device.peripheral.identifier);
    }
    
    [self checkCurrentRoom];
    
    RoomPictureCell *cell = (RoomPictureCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *roomName = [self.rooms objectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSLog(@"Current room is: %@",self.currentRoom);
    
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
        self.currentRoom = roomName;
        [defaults setObject:[NSArray arrayWithArray:devicesUUID] forKey:roomName];
        [self PrintRoomDevices];
    }
    
    /* Or it belongs to a room */
    else {

        /* If the user select the same room */
        if ([roomName isEqualToString:self.currentRoom]) {
            
            /* if it's already selected, diselect it */
            if (cell.isSelected) {
                [cell setUnSelected];
                NSLog(@"The user deselects the same room which is: %@",self.currentRoom);
                self.currentRoom = NULL;

                /* Remove the device in this room saved in data */
                for (Device *device in self.devices)
                {
                    NSMutableArray *identifiers = [NSMutableArray arrayWithArray:[defaults objectForKey:roomName]];
                    NSString *UUIDString = device.peripheral.identifier.UUIDString;
                    
                    if ([identifiers containsObject:UUIDString]) {
                        NSLog(@"I found the identifiers, I will have to remove it in the UserDefault now!");
                        [identifiers removeObject:UUIDString];
                        [defaults setObject:[NSArray arrayWithArray:identifiers] forKey:roomName];
                        [defaults synchronize];
                    }
                }
            }
            [self PrintRoomDevices];
        }
        
        /* If the user selects another room */
        else {
            NSLog(@"The user selected another room we have to delete the previous room: %@", self.currentRoom);
            
            /* Remove the devices from its previous room */
            for (Device *device in self.devices)
            {
                NSMutableArray *identifiers = [NSMutableArray arrayWithArray:[defaults objectForKey:self.currentRoom]];
                NSString *UUIDString = device.peripheral.identifier.UUIDString;
                
                if ([identifiers containsObject:UUIDString]) {
                    NSLog(@"I found the previous identifiers, I will have to delete the previous room from the UserDefault now!");
                    [identifiers removeObject:UUIDString];
                    [defaults setObject:[NSArray arrayWithArray:identifiers] forKey:self.currentRoom];
                    [defaults synchronize];
                }
            }
            
            /* Deselect all the other cells */
            for (RoomPictureCell *cell in [[self collectionView]visibleCells]) {
                [cell setUnSelected];
            }
            
            self.currentRoom = roomName;
            
            /* Select this room */
            [cell setIsSelected];
            
            /* Update the data */
            NSMutableArray *devicesUUID = [NSMutableArray arrayWithArray:[defaults objectForKey:roomName]];
            for (Device *device in self.devices) {
                [devicesUUID addObject:device.peripheral.identifier.UUIDString];
            }
            
            NSLog(@"Updating %@",roomName);
            [defaults setObject:[NSArray arrayWithArray:devicesUUID] forKey:roomName];
            [defaults synchronize];
            [self PrintRoomDevices];
        }
    }
    
    
    if (self.currentRoom) {
        self.currentRoomLabel.text = self.currentRoom;
    }
    
    else {
        self.currentRoomLabel.text = [NSString stringWithFormat:@"Please Select Room"];
    }
    
    [defaults synchronize];
}


@end
