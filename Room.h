//
//  Room.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/9/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Hotel, Reservation;

@interface Room : NSManagedObject

@property (nonatomic) int16_t beds;
@property (nonatomic, retain) NSData * image;
@property (nonatomic) int16_t number;
@property (nonatomic) int16_t rate;
@property (nonatomic, retain) UIImage *actualImage;
@property (nonatomic, retain) Hotel *hotel;
@property (nonatomic, retain) NSSet *reservations;
@end

@interface Room (CoreDataGeneratedAccessors)

- (void)addReservationsObject:(Reservation *)value;
- (void)removeReservationsObject:(Reservation *)value;
- (void)addReservations:(NSSet *)values;
- (void)removeReservations:(NSSet *)values;

@end
