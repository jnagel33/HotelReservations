//
//  HotelJSONParserService.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/10/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CoreDataStack;

@interface HotelJSONParserService : NSObject

+(void)parseJSONFromSeedFile:(CoreDataStack *)coreDataStack;

@end
