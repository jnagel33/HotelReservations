//
//  RoomTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/5/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "RoomTableViewCell.h"

@implementation RoomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    self.bedsLabel = [[UILabel alloc]init];
    self.bedsLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.bedsLabel];
    self.rateLabel = [[UILabel alloc]init];
    self.rateLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.rateLabel];
    NSDictionary *views = @{@"bedsLabel":self.bedsLabel, @"rateLabel":self.rateLabel};
    [self setConstraintsForContentViewWithViews:views];
    
  }
  return self;
}

//MARK: Constraints

-(void)setConstraintsForContentViewWithViews:(NSDictionary *)views {
  
  NSArray *hNameLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[bedsLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hNameLayoutConstraint];
  NSArray *vNameLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[bedsLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:vNameLayoutConstraint];
  
  NSArray *hLocationLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[rateLabel]-8-|" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hLocationLayoutConstraint];
  NSArray *vLocationLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[rateLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:vLocationLayoutConstraint];
  
}

@end
