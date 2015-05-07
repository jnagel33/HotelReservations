//
//  DateValidationService.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/7/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "DateValidationService.h"

@implementation DateValidationService

+(BOOL)validateFromDate:(NSDate *)fromDate AndToDate:(NSDate *)toDate {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  BOOL sameDay = [calendar isDate:fromDate inSameDayAsDate:toDate];
  NSComparisonResult comparison = [fromDate compare:toDate];
  if (comparison == NSOrderedAscending && !sameDay) {
    return true;
  }
  return false;
}

+(BOOL)validateFromDateIsTodayOrLater:(NSDate *)fromDate {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  BOOL sameDay = [calendar isDate:fromDate inSameDayAsDate:[NSDate date]];
  NSComparisonResult comparison = [fromDate compare:[NSDate date]];
  if (comparison == NSOrderedDescending || sameDay) {
    return true;
  }
  return false;
}

@end
