//
//  HotelTableViewCell.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/4/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelTableViewCell : UITableViewCell

@property(strong,nonatomic)UILabel *nameLabel;
@property(strong,nonatomic)UILabel *locationLabel;
@property(strong,nonatomic)UILabel *roomCountLabel;

@end
