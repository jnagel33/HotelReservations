//
//  HotelServiceTests.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/7/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CoreDataStack.h"
#import "HotelService.h"
#import "Hotel.h"
#import "Room.h"
#import "Reservation.h"
#import "Guest.h"

@interface HotelServiceTests : XCTestCase

@property(strong,nonatomic)CoreDataStack *coreDataStack;
@property(strong,nonatomic)HotelService *hotelService;

@end

@implementation HotelServiceTests

- (void)setUp {
  [super setUp];
  self.coreDataStack = [[CoreDataStack alloc]initForTesting];
  self.hotelService = [[HotelService alloc]initWithCoreDataStack:self.coreDataStack];
}

-(Hotel *)setupHotelWithName:(NSString *)name {
  Hotel *hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  hotel.name = name;
  hotel.location = @"Location";
  return hotel;
}

-(Room *)setupRoomWithNumber:(int16_t)number Andrate:(int16_t)rate AndBeds:(int16_t)beds AndHotel:(Hotel *)hotel {
  Room *room = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  room.number = number;
  room.rate = rate;
  room.beds = beds;
  room.hotel = hotel;
  return room;
}

-(Guest *)setUpGuestWithFirstName:(NSString *)firstName AndLastName:(NSString *)lastName {
  Guest *guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  guest.firstName = @"test";
  guest.lastName = @"test";
  return guest;
}

-(Reservation *)setupReservationWithFromDate:(NSDate *)fromDate AndToDate:(NSDate *)toDate AndRoom:(Room *)room AndReservation:(Guest *)guest {
  Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  reservation.startDate = fromDate;
  reservation.endDate = toDate;
  reservation.room = room;
  reservation.guests = [[NSSet alloc]initWithObjects:guest, nil];
  return reservation;
}

- (void)tearDown {
  self.coreDataStack = nil;
  self.hotelService = nil;
  [super tearDown];
}

- (void)testFetchAllHotelsZeroResults {
  NSArray *hotels = [self.hotelService fetchAllHotels];
  XCTAssert(hotels.count == 0, @"Failed fetch all hotels with zero results");
}

- (void)testFetchAllHotelsManyResults {
  Hotel *hotel1 = [self setupHotelWithName:@"test"];
  [self setupRoomWithNumber:1 Andrate:1 AndBeds:1 AndHotel:hotel1];
  
  Hotel *hotel2 = [self setupHotelWithName:@"test2"];
  [self setupRoomWithNumber:2 Andrate:2 AndBeds:2 AndHotel:hotel2];
  
  NSArray *hotels = [self.hotelService fetchAllHotels];
  XCTAssert(hotels.count == 2, @"Failed fetch hotels with many results");
}

-(void)testFetchAvailableRoomsWithNoReservations {
  int16_t bedCount = 1;
  Hotel *hotel = [self setupHotelWithName:@"test"];
  [self setupRoomWithNumber:1 Andrate:1 AndBeds:bedCount AndHotel:hotel];
  
  NSDate *today = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *tomorrow = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:today options:0];
  
  NSFetchedResultsController *fetchedResultsController = [self.hotelService produceFetchResultsControllerForAvailableRoomsFromDate:today toDate:tomorrow withBedCount:bedCount];
  NSError *fetchError;
  [fetchedResultsController performFetch:&fetchError];
  XCTAssert(fetchedResultsController.sections.count == 1, @"Failed fetch for available rooms with no reservations");
}

-(void)testFetchAvailableRoomsWithReservation {
  int16_t bedCount = 1;
  Hotel *hotel = [self setupHotelWithName:@"test"];
  Room *room = [self setupRoomWithNumber:1 Andrate:1 AndBeds:bedCount AndHotel:hotel];
  NSDate *today = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *tomorrow = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:today options:0];
  Guest *guest = [self setUpGuestWithFirstName:@"test" AndLastName:@"test"];
  [self setupReservationWithFromDate:today AndToDate:tomorrow AndRoom:room AndReservation:guest];
  NSFetchedResultsController *fetchedResultsController = [self.hotelService produceFetchResultsControllerForAvailableRoomsFromDate:today toDate:tomorrow withBedCount:bedCount];
  XCTAssert(fetchedResultsController.sections.count == 0, @"Failed fetch for available rooms with reservations");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
