//
//  NumberOfBedsTableViewCell.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberOfBedsTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *bedsLabel;
@property(nonatomic,strong)UIButton *plusButton;
@property(nonatomic,strong)UIButton *minusButton;

@end
