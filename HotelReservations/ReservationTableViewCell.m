//
//  ReservationTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "ReservationTableViewCell.h"

@implementation ReservationTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.nameLabel];
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.detailLabel];
    NSDictionary *views = @{@"nameLabel":self.nameLabel, @"detailLabel":self.detailLabel};
    [self setConstraintsForContentViewWithViews:views];
    
  }
  return self;
}

//MARK: Constraints

-(void)setConstraintsForContentViewWithViews:(NSDictionary *)views {
  
  NSArray *hNameLabelLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[nameLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hNameLabelLayoutConstraint];
  
  NSLayoutConstraint *nameLabelCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:nameLabelCenterYLayoutConstraint];
  
  NSLayoutConstraint *detailLabelCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:detailLabelCenterYLayoutConstraint];
  
  NSLayoutConstraint *detailLabelCenterXLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  [self.contentView addConstraint:detailLabelCenterXLayoutConstraint];
}

@end
