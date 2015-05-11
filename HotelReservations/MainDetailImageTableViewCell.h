//
//  HotelTableViewCell.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/4/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kMainDetailImageTableViewCellHeight = 100;

@interface MainDetailImageTableViewCell : UITableViewCell

@property(strong,nonatomic)UILabel *mainLabel;
@property(strong,nonatomic)UILabel *detailLabel;
@property(strong,nonatomic)UIImageView *mainImageView;

@end
