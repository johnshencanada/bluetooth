//
//  LightBulbRoomCollectionViewController.h
//  nextHome
//
//  Created by john on 9/16/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightBulbRoomCollectionViewController : UICollectionViewController

- (id) initWithDevices:(NSArray *)devices;
@property (strong,nonatomic) NSArray *devices;
@end
