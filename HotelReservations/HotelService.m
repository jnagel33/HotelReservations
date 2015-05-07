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

-(NSFetchedResultsController *) produceFetchResultsControllerForAvailableRoomsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate withBedCount:(int16_t)bedCount {
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
  NSPredicate *finalPredicate = [NSPredicate predicateWithFormat:@"NOT self IN %@ AND beds >= %@", rooms, @(bedCount)];
  finalRequest.predicate = finalPredicate;
  
  NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:finalRequest managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:@"hotel.name" cacheName:@"AvailableRoomsCache"];
  
  return fetchedResultsController;
}

-(void)makeReservationForRoom:(Room *)room withFromDate:(NSDate *)fromDate andToDate:(NSDate *)toDate forGuest:(Guest *)guest {
  Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  reservation.room = room;
  reservation.startDate = fromDate;
  reservation.endDate = toDate;
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

@end
