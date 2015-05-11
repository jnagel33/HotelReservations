//
//  HotelService.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "HotelService.h"
#import "CoreDataStack.h"
#import "Reservation.h"
#import "RandomConfirmationIDGenerator.h"

@implementation HotelService

-(instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack {
  self = [super init];
  if (self) {
    self.coreDataStack = coreDataStack;
  }
  return self;
}

-(NSArray *)fetchAllHotels {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"stars" ascending:false];
  [fetchRequest setSortDescriptors:@[sortDescriptor]];
  NSError *fetchError;
  NSArray *allHotels = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
  if (fetchError != nil) {
    NSLog(@"%@",fetchError.localizedDescription);
    return nil;
  }
  return allHotels;
}

-(NSFetchedResultsController *) produceFetchResultsControllerForAvailableRoomsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withBedCount:(int16_t)bedCount andLocation:(NSString *)location {
  [NSFetchedResultsController deleteCacheWithName:@"AvailableRoomsCache"];
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", toDate, fromDate];
  fetchRequest.predicate = predicate;
  
  NSError *fetchError;
  NSArray *reservations = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
  NSMutableArray *rooms = [[NSMutableArray alloc] init];
  for (Reservation *reservation in reservations) {
    [rooms addObject:reservation.room];
  }
  
  NSFetchRequest *finalRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
  NSSortDescriptor *hotelNameSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"hotel.name" ascending:false];
  finalRequest.sortDescriptors = @[hotelNameSortDescriptor];
  
  NSPredicate *mainPredicate = [NSPredicate predicateWithFormat:@"NOT self IN %@ AND beds >= %@", rooms, @(bedCount)];
  if (location != nil) {
    NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"hotel.location == %@", location];
    mainPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[mainPredicate,locationPredicate]];
  }
  finalRequest.predicate = mainPredicate;
  
  NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:finalRequest managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:@"hotel.name" cacheName:@"AvailableRoomsCache"];
  
  return fetchedResultsController;
}

-(void)makeReservationForRoom:(Room *)room withFromDate:(NSDate *)fromDate andToDate:(NSDate *)toDate forGuest:(Guest *)guest {
  Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  reservation.room = room;
  reservation.startDate = fromDate;
  reservation.endDate = toDate;
  reservation.confirmationID = [RandomConfirmationIDGenerator generateConfirmationID];
  NSSet *guests = [NSSet setWithObjects:guest, nil];
  reservation.guests = guests;
  
  NSError *saveError;
  [self.coreDataStack.managedObjectContext save:&saveError];
  if (saveError) {
    NSLog(@"%@", saveError.localizedDescription);
  }
}

-(NSArray *)fetchAllGuests {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Guest"];
  NSSortDescriptor *lastNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:true];
  fetchRequest.sortDescriptors = @[lastNameSortDescriptor];
  NSError *fetchError;
  NSArray *guests = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
  if (fetchError != nil) {
    return nil;
  }
  return guests;
}

-(void)deleteReservation:(Reservation *)reservation {
  [self.coreDataStack.managedObjectContext deleteObject:reservation];
  NSError *deleteError;
  [self.coreDataStack.managedObjectContext save:&deleteError];
  if (deleteError != nil) {
    NSLog(@"%@",deleteError.localizedDescription);
  }
}


-(NSArray *)fetchTodaysReservations {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
  NSSortDescriptor *startDateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:true];
  fetchRequest.sortDescriptors = @[startDateSortDescriptor];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = [NSDate date];
  NSDate *startOfDay = [calendar startOfDayForDate:date];
  NSDateComponents *components = [calendar components:(  NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:date];
  
  [components setHour:23];
  [components setMinute:59];
  [components setSecond:59];
  
  NSDate *endOfDay = [calendar dateFromComponents:components];
  
  NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"startDate <= %@", endOfDay];
  NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"startDate >= %@", startOfDay];
  NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[firstPredicate, secondPredicate]];
  fetchRequest.predicate = compoundPredicate;
  NSError *fetchError;
  NSArray *reservations = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
  if (fetchError != nil) {
    return nil;
  }
  return reservations;
}

@end
