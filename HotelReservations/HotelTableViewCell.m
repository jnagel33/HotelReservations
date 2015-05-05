//
//  HotelTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/4/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "HotelTableViewCell.h"

@implementation HotelTableViewCell


-(void)layoutSubviews {
  self.nameLabel.translatesAutoresizingMaskIntoConstraints = false;
  self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 100, 20)];
  [self.contentView addSubview:self.nameLabel];
  self.locationLabel.translatesAutoresizingMaskIntoConstraints = false;
  self.locationLabel = [[UILabel alloc]init];
  self.locationLabel.backgroundColor = [UIColor blueColor];
  [self.contentView addSubview:self.locationLabel];
  NSDictionary *views = @{@"nameLabel":self.nameLabel, @"locationLabel":self.locationLabel};
  [self setConstraintsForRootView:self.contentView withView:views];
  [self.contentView layoutIfNeeded];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//MARK: Constraints

-(void)setConstraintsForRootView:(UIView *)view withView:(NSDictionary *)views {
  NSArray *hNameLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[nameLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hNameLayoutConstraint];
  NSArray *vNameLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[nameLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:vNameLayoutConstraint];
  
  NSArray *hLocationLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[locationLabel]-8-|" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hLocationLayoutConstraint];
  NSArray *vLocationLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[locationLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:vLocationLayoutConstraint];
}

@end
