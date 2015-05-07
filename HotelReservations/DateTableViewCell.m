//
//  DateTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/5/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "DateTableViewCell.h"
#import "HotelReservationsStyleKit.h"

@implementation DateTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    self.fromToLabel = [[UILabel alloc]init];
    self.fromToLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.fromToLabel];
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.textColor = [HotelReservationsStyleKit blueDark];
    self.dateLabel.text = @"Choose a Date";
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.dateLabel];
    NSDictionary *views = @{@"fromToLabel":self.fromToLabel, @"dateLabel":self.dateLabel};
    [self setConstraintsForContentViewWithViews:views];
  }
  return self;
}

-(void)setConstraintsForContentViewWithViews:(NSDictionary *)views {
  
  NSArray *hFromToLabelLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[fromToLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hFromToLabelLayoutConstraint];
  
  NSLayoutConstraint *fromToLabelYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.fromToLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:fromToLabelYLayoutConstraint];
  
  NSLayoutConstraint *dateLabelYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:dateLabelYLayoutConstraint];
  
  NSLayoutConstraint *dateLabelXLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  [self.contentView addConstraint:dateLabelXLayoutConstraint];
}

@end
