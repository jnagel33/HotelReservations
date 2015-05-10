//
//  HotelTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/4/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "MainDetailImageTableViewCell.h"

@implementation MainDetailImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self)
  {
    self.mainImageView = [[UIImageView alloc]init];
    self.mainImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.mainImageView];
    self.mainLabel = [[UILabel alloc]init];
    self.mainLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.mainLabel];
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.detailLabel];
    NSDictionary *views = @{@"mainImageView": self.mainImageView, @"mainLabel":self.mainLabel, @"detailLabel":self.detailLabel};
    [self setConstraintsForContentViewWithViews:views];
  }
  return self;
}

//MARK: Constraints

-(void)setConstraintsForContentViewWithViews:(NSDictionary *)views {
  
  NSArray *hHotelLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mainImageView(100)]-8-[mainLabel]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hHotelLayoutConstraint];
  NSLayoutConstraint *mainLabelCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.mainLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:mainLabelCenterYLayoutConstraint];
  
  NSLayoutConstraint *detailLabelCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.detailLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:detailLabelCenterYLayoutConstraint];
  
  NSArray *hDetailLabelLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[detailLabel]-8-|" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hDetailLabelLayoutConstraint];
  
  NSLayoutConstraint *mainImageViewHeightLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.mainImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
  [self.contentView addConstraint:mainImageViewHeightLayoutConstraint];
  
  NSLayoutConstraint *mainImageViewCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.mainImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:mainImageViewCenterYLayoutConstraint];
}

@end
