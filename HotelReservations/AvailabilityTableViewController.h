//
//  AvailabilityTableViewController.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/5/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailabilityTableViewController : UITableViewController

@property(strong,nonatomic)NSDate *fromDate;
@property(strong,nonatomic)NSDate *toDate;

@end
