//
//  RoomTableViewCell.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/5/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomTableViewCell : UITableViewCell

@property(strong,nonatomic)UILabel *numberLabel;
@property(strong,nonatomic)UILabel *bedsLabel;
@property(strong,nonatomic)UILabel *rateLabel;

@end
