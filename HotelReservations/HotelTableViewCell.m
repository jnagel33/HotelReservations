//
//  HotelTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/4/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "HotelTableViewCell.h"

@implementation HotelTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self)
  {
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.nameLabel];
    self.roomCountLabel = [[UILabel alloc]init];
    self.roomCountLabel.textColor = [UIColor redColor];
    self.roomCountLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.roomCountLabel];
    self.locationLabel = [[UILabel alloc]init];
    self.locationLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.locationLabel];
    NSDictionary *views = @{@"nameLabel":self.nameLabel, @"locationLabel":self.locationLabel, @"roomCountLabel": self.roomCountLabel};
    [self setConstraintsForContentViewWithViews:views];
  }
  return self;
}

//MARK: Constraints

-(void)setConstraintsForContentViewWithViews:(NSDictionary *)views {
  
  NSArray *hNameLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[nameLabel]-8-[roomCountLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hNameLayoutConstraint];
  NSArray *vNameLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[nameLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:vNameLayoutConstraint];
  
  NSArray *hLocationLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[locationLabel]-8-|" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hLocationLayoutConstraint];
  NSArray *vLocationLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[locationLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:vLocationLayoutConstraint];
  
  NSArray *vRoomCountLabel = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[roomCountLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:vRoomCountLabel];
}

@end
