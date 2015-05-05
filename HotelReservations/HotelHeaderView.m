//
//  HotelHeaderView.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/5/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "HotelHeaderView.h"
#import "HotelReservationsStyleKit.h"

@implementation HotelHeaderView


- (void)drawRect:(CGRect)rect {
  [HotelReservationsStyleKit drawSectionHeaderWithFrame:rect];
}

@end
