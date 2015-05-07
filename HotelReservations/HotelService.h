//
//  HotelService.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataStack.h"
@class Room;
@class Guest;


@interface HotelService : NSObject

@property(strong,nonatomic)CoreDataStack *coreDataStack;

-(instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack;

-(NSArray *)fetchAllHotels;

-(NSFetchedResultsController *) produceFetchResultsControllerForAvailableRoomsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withBedCount:(int16_t)bedCount;

-(void)makeReservationForRoom:(Room *)room withFromDate:(NSDate *)fromDate andToDate:(NSDate *)toDate forGuest:(Guest *)guest;
-(NSArray *)fetchAllGuests;

@end
