//
//  NumberOfBedsTableViewCell.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "NumberOfBedsTableViewCell.h"
#import "HotelReservationsStyleKit.h"

@interface NumberOfBedsTableViewCell ()

@property(strong,nonatomic)UIView *customContainerView;

@end

@implementation NumberOfBedsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    self.selectionStyle = UITableViewCellEditingStyleNone;
    self.customContainerView = [[UIView alloc]init];
    self.customContainerView.translatesAutoresizingMaskIntoConstraints = false;
    self.bedsLabel = [[UILabel alloc]init];
    self.bedsLabel.translatesAutoresizingMaskIntoConstraints = false;
    [self.customContainerView addSubview:self.bedsLabel];
    self.minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.minusButton setImage:[HotelReservationsStyleKit imageOfMinusButtonWithFrame:self.contentView.frame] forState:UIControlStateNormal];
    [self.minusButton setImage:[HotelReservationsStyleKit imageOfMinusButtonWithFrame:self.contentView.frame] forState:UIControlStateHighlighted];
    self.minusButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.customContainerView addSubview:self.minusButton];
    
    self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.plusButton setImage:[HotelReservationsStyleKit imageOfPlusButtonWithFrame:self.contentView.frame] forState:UIControlStateNormal];
    [self.plusButton setImage:[HotelReservationsStyleKit imageOfPlusButtonWithFrame:self.contentView.frame] forState:UIControlStateHighlighted];
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
  
  NSLayoutConstraint *containerViewXLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.customContainerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.contentView addConstraint:containerViewXLayoutConstraint];
  
  NSArray *vContainerViewLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[containerView]|" options:0 metrics:nil views:views];
  [self.contentView addConstraints:vContainerViewLayoutConstraints];
  
  NSArray *hContainerViewLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-75-[containerView]-80-|" options:0 metrics:nil views:views];
  [self.contentView addConstraints:hContainerViewLayoutConstraints];
  
  NSArray *hContainerSubviewsLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[minusButton]-[bedsLabel(80)]-[plusButton]|" options:0 metrics:nil views:views];
  [self.customContainerView addConstraints:hContainerSubviewsLayoutConstraints];
  
  
  NSArray *vMinusButtonLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[minusButton]|" options:0 metrics:nil views:views];
  [self.customContainerView addConstraints:vMinusButtonLayoutConstraints];
  
  NSArray *vPlusButtonLayoutConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[plusButton]|" options:0 metrics:nil views:views];
  [self.customContainerView addConstraints:vPlusButtonLayoutConstraints];
  
  NSArray *vBedsLabelLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bedsLabel]|" options:0 metrics:nil views:views];
  [self.customContainerView addConstraints:vBedsLabelLayoutConstraint];
  
  
  NSLayoutConstraint *buttonEqualWidthLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.plusButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.minusButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
  [self.customContainerView addConstraint:buttonEqualWidthLayoutConstraint];
}

@end
