//
//  ReserveRoomTableViewController.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Room;

@interface ReserveRoomTableViewController : UITableViewController

@property(strong,nonatomic)Room *selectedRoom;
@property(strong,nonatomic)NSDate *fromDate;
@property(strong,nonatomic)NSDate *toDate;

@end
