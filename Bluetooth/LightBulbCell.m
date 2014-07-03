//
//  LightBulbCell.m
//  Bluetooth
//
//  Created by john on 7/1/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "LightBulbCell.h"

@implementation LightBulbCell


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.name = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, 200, 20)];
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.name];
        
        self.identifier = [[UILabel alloc]initWithFrame: CGRectMake(0, 20, 300, 20)];
        self.identifier.textAlignment = NSTextAlignmentLeft;
        self.identifier.font = [UIFont boldSystemFontOfSize:8];
        [self.contentView addSubview:self.identifier];
        
        //
        //        self.state = [[UILabel alloc]initWithFrame: CGRectMake(100, 50 , 20, 20)];
        //        self.state.textAlignment = NSTextAlignmentRight;
        //        self.state.font = [UIFont boldSystemFontOfSize:12];
        //        [self.contentView addSubview:self.state];

    }
    return self;
    
}
- (void)drawRect:(CGRect)rect
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
