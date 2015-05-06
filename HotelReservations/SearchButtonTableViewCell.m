//
//  SearchButtonTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/5/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "SearchButtonTableViewCell.h"
#import "HotelReservationsStyleKit.h"

@implementation SearchButtonTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    self.searchLabel = [[UILabel alloc]init];
    self.searchLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.searchLabel.text = @"Search";
    self.searchLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.searchLabel];
    self.backgroundImage = [[UIImageView alloc]initWithImage:[HotelReservationsStyleKit imageOfSectionHeaderWithFrame:self.contentView.frame]];
    self.backgroundImage.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.backgroundImage];
    NSDictionary *views = @{@"searchLabel": self.searchLabel, @"backgroundImage": self.backgroundImage};
    [self setConstraintsForContentViewWithViews:views];
    [self.contentView bringSubviewToFront:self.searchLabel];
  }
  return self;
}

-(void)setConstraintsForContentViewWithViews:(NSDictionary *)views {

  NSLayoutConstraint *backgroundImageYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:backgroundImageYLayoutConstraint];
  
  NSLayoutConstraint *backgroundImageXLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  [self.contentView addConstraint:backgroundImageXLayoutConstraint];
  
  NSLayoutConstraint *backgroundImageWidthLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
  [self.contentView addConstraint:backgroundImageWidthLayoutConstraint];
  
  NSLayoutConstraint *backgroundImageHeightLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.backgroundImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
  [self.contentView addConstraint:backgroundImageHeightLayoutConstraint];
  
  NSLayoutConstraint *searchLabelXLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.searchLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  [self.contentView addConstraint:searchLabelXLayoutConstraint];
  
  NSLayoutConstraint *searchLabelYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.searchLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:searchLabelYLayoutConstraint];
  
}

@end
