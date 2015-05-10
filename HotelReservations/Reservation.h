//
//  Reservation.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/9/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Guest, Room;

@interface Reservation : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * confirmationID;
@property (nonatomic, retain) NSSet *guests;
@property (nonatomic, retain) Room *room;
@end

@interface Reservation (CoreDataGeneratedAccessors)

- (void)addGuestsObject:(Guest *)value;
- (void)removeGuestsObject:(Guest *)value;
- (void)addGuests:(NSSet *)values;
- (void)removeGuests:(NSSet *)values;

@end
