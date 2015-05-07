//
//  DateValidationService.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/7/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateValidationService : NSObject

+(BOOL)validateFromDate:(NSDate *)fromDate AndToDate:(NSDate *)toDate;
+(BOOL)validateFromDateIsTodayOrLater:(NSDate *)fromDate;

@end
