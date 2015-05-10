//
//  GuestReservationsTableViewController.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/7/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Guest;

@interface GuestReservationsTableViewController : UITableViewController

@property(strong,nonatomic)Guest* selectedGuest;

@end
