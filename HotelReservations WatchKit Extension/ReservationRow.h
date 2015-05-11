//
//  ReservationRow.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/10/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <WatchKit/WatchKit.h>

@interface ReservationRow : NSObject
@property (weak, nonatomic) IBOutlet WKInterfaceImage *roomImageView;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *hotelAndRoomLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *guestLabel;

@end
