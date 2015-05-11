//
//  HotelJSONParserService.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/10/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "HotelJSONParserService.h"
#import <CoreData/CoreData.h>
#import "Hotel.h"
#import "Room.h"
#import "AppDelegate.h"
#import "HotelService.h"
#import "CoreDataStack.h"

@implementation HotelJSONParserService

+(void)parseJSONFromSeedFile:(CoreDataStack *)coreDataStack {
  NSString *filePath = [[NSBundle mainBundle]pathForResource:@"seed" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  NSError *error;
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  NSArray *hotels = jsonObject[@"Hotels"];
  for (NSDictionary *hotel in hotels) {
    Hotel *newHotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:coreDataStack.managedObjectContext];
    newHotel.name = hotel[@"name"];
    newHotel.location = hotel[@"location"];
    NSNumber *starsNum = hotel[@"stars"];
    newHotel.stars = starsNum.intValue;
    newHotel.createdTimeStamp = [[NSDate date]timeIntervalSince1970];
    NSArray *rooms = hotel[@"rooms"];
    for (NSDictionary *room in rooms) {
      Room *newRoom = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:coreDataStack.managedObjectContext];
      NSNumber *number = room[@"number"];
      newRoom.number = number.intValue;
      NSNumber *beds = room[@"beds"];
      newRoom.beds = beds.intValue;
      NSNumber *rate = room[@"rate"];
      newRoom.rate = rate.intValue;
      newRoom.hotel = newHotel;
    }
  }
}

@end
