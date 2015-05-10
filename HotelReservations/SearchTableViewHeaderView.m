//
//  SearchTableViewHeaderView.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/8/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "SearchTableViewHeaderView.h"
#import "HotelReservationsStyleKit.h"

@implementation SearchTableViewHeaderView

- (void)drawRect:(CGRect)rect {
  [HotelReservationsStyleKit drawTableViewHeaderWithFrame:rect];
  
}

@end
