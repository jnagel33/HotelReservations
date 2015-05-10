//
//  NumberOfBedsTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "NumberOfBedsTableViewCell.h"

@interface NumberOfBedsTableViewCell ()

@property(strong,nonatomic)UIView *customContainerView;

@end

@implementation NumberOfBedsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.customContainerView = [[UIView alloc]init];
    self.customContainerView.translatesAutoresizingMaskIntoConstraints = false;
    self.bedsLabel = [[UILabel alloc]init];
    self.bedsLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.customContainerView addSubview:self.bedsLabel];
    self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.minusButton setImage:[UIImage imageNamed:@"MinusButton"] forState:UIControlStateNormal];
    [self.minusButton setImage:[UIImage imageNamed:@"MinusButton"] forState:UIControlStateHighlighted];
    self.minusButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.customContainerView addSubview:self.minusButton];
    
    self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.plusButton setImage:[UIImage imageNamed:@"PlusButton"] forState:UIControlStateNormal];
    [self.plusButton setImage:[UIImage imageNamed:@"PlusButton"] forState:UIControlStateHighlighted];
    self.plusButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.customContainerView addSubview:self.plusButton];
    
    [self.contentView addSubview:self.customContainerView];
    
    NSDictionary *views = @{@"containerView": self.customContainerView,@"bedsLabel": self.bedsLabel, @"plusButton": self.plusButton, @"minusButton": self.minusButton};
    
    self.bedsLabel.text = @"1+ Bed(s)";
    [self setConstraintsForContentViewWithViews:views];
    
  }
  return self;
}
-(void)setConstraintsForContentViewWithViews:(NSDictionary *)views {
  NSLayoutConstraint *containerViewYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.customContainerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:containerViewYLayoutConstraint];
  
  NSLayoutConstraint *containerViewXLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.customContainerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  [self.contentView addConstraint:containerViewXLayoutConstraint];
  
  NSArray *vContainerViewLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[containerView]|" options:0 metrics:nil views:views];
  [self.contentView addConstraints:vContainerViewLayoutConstraints];
  
  NSArray *hContainerSubviewsLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[minusButton(40)]-[bedsLabel(80)]-[plusButton(40)]|" options:0 metrics:nil views:views];
  [self.customContainerView addConstraints:hContainerSubviewsLayoutConstraints];
  
  NSArray *vBedsLabelLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bedsLabel]|" options:0 metrics:nil views:views];
  [self.customContainerView addConstraints:vBedsLabelLayoutConstraint];
  
  NSArray *vMinusButtonHeightLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[minusButton(40)]" options:0 metrics:nil views:views];
  [self.customContainerView addConstraints:vMinusButtonHeightLayoutConstraint];\
  
  NSArray *vPlusButtonHeightLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[plusButton(40)]" options:0 metrics:nil views:views];
  [self.customContainerView addConstraints:vPlusButtonHeightLayoutConstraint];
  
  NSLayoutConstraint *minusButtonCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.minusButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.customContainerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.customContainerView addConstraint:minusButtonCenterYLayoutConstraint];
  
  NSLayoutConstraint *plusButtonCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.plusButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.customContainerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.customContainerView addConstraint:plusButtonCenterYLayoutConstraint];
}

@end
