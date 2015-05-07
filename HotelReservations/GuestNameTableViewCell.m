//
//  GuestNameTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "GuestNameTableViewCell.h"

@implementation GuestNameTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.nameLabel];
    self.nameTextField = [[UITextField alloc]init];
    [self.nameTextField setTextAlignment:NSTextAlignmentLeft];
    self.nameTextField.translatesAutoresizingMaskIntoConstraints = false;
    [self.contentView addSubview:self.nameTextField];
    NSDictionary *views = @{@"nameLabel":self.nameLabel, @"nameTextField":self.nameTextField};
    [self setConstraintsForContentViewWithViews:views];

  }
  return self;
}

//MARK: Constraints

-(void)setConstraintsForContentViewWithViews:(NSDictionary *)views {
  
  NSArray *hNameLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[nameLabel]-[nameTextField]" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hNameLayoutConstraint];
  
  NSLayoutConstraint *nameLabelCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:nameLabelCenterYLayoutConstraint];
  
  NSLayoutConstraint *nameTextFieldCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.nameTextField attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:nameTextFieldCenterYLayoutConstraint];
}


@end
