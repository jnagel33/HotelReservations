//
//  DateTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/5/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "PickerHeaderViewCell.h"
#import "HotelReservationsStyleKit.h"

@implementation PickerHeaderViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    self.infoLabel = [[UILabel alloc]init];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.infoLabel];
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.textColor = [HotelReservationsStyleKit blueDark];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
//    self.detailLabel.text = @"--Choose a Date--";
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.contentView addSubview:self.detailLabel];
    NSDictionary *views = @{@"infoLabel":self.infoLabel, @"detailLabel":self.detailLabel};
    [self setConstraintsForContentViewWithViews:views];
  }
  return self;
}

-(void)awakeFromNib {
  
}

-(void)setConstraintsForContentViewWithViews:(NSDictionary *)views {
  
  NSArray *hInfoLabelLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[infoLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hInfoLabelLayoutConstraint];
  
  NSLayoutConstraint *infoLabelYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:infoLabelYLayoutConstraint];
  
  NSLayoutConstraint *detailLabelYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:detailLabelYLayoutConstraint];
  
  NSLayoutConstraint *detailLabelXLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  [self.contentView addConstraint:detailLabelXLayoutConstraint];
}

@end
