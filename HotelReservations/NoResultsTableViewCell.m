//
//  NoResultsTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/9/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "NoResultsTableViewCell.h"

@implementation NoResultsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.userInteractionEnabled = false;
    self.mainLabel = [[UILabel alloc]init];
    self.mainLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.mainLabel];
    
    NSLayoutConstraint *mainLabelCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.mainLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.contentView addConstraint:mainLabelCenterYLayoutConstraint];
    
    NSLayoutConstraint *mainLabelCenterXLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.mainLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.contentView addConstraint:mainLabelCenterXLayoutConstraint];
  }
  return self;
}

@end
