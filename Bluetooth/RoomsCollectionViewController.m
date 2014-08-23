//
//  RoomsCollectionViewController.m
//  Bluetooth
//
//  Created by john on 8/22/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "RoomsCollectionViewController.h"
#import "RoomCell.h"
#import "Dashboard.h"
#import "HeaderCellView.h"

@interface RoomsCollectionViewController ()
//view
@property (strong,nonatomic) Dashboard *dashBoard;
@end


@implementation RoomsCollectionViewController
static NSString * const reuseIdentifier = @"Room";


- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(320, 80);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    layout.headerReferenceSize = CGSizeMake(0,0);
    self = [super initWithCollectionViewLayout:layout];
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
    self.collectionView.frame = CGRectMake(0, self.view.frame.size.height/4, 320, 400);
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[RoomCell class] forCellWithReuseIdentifier:@"Room"];
    [self.collectionView registerClass:[HeaderCellView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    self.dashBoard = [[Dashboard alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/4)];
    [self.view addSubview:self.dashBoard];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        return 2;
    }
    
    /* Number of un-added cells */
    else {
        return 3;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RoomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Room" forIndexPath:indexPath];
    return cell;
}


#pragma mark <UICollectionViewDelegate>

#pragma mark <UICollectionViewDelegateFlowLayou>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 40);
    
}

/* Set the header and organize them into 1.Rooms 2.Uncategoried Products */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    HeaderCellView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                   UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    int sectionNumber = indexPath.section;
    if (sectionNumber == 0) {
        [headerView.category setText:@"Rooms"];
    } else if (sectionNumber == 1) {
        [headerView.category setText:@"Uncategorized Products"];
    }
    return headerView;
}


@end
