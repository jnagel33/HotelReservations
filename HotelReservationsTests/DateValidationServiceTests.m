//
//  DateValidationServiceTests.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/7/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DateValidationService.h"

@interface DateValidationServiceTests : XCTestCase

@end

@implementation DateValidationServiceTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDateValidationFromToDatesSameDay {
  NSDate *today = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *hourFromNow = [calendar dateByAddingUnit:NSCalendarUnitHour value:1 toDate:today options:0];
  BOOL isValid = [DateValidationService validateFromDate:today AndToDate:hourFromNow];
  XCTAssert(!isValid , @"Error Date Validation - From To date with same day");
}

- (void)testDateValidationFromDateBeforeToDate {
  NSDate *today = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *tomorrow = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:today options:0];
  BOOL isValid = [DateValidationService validateFromDate:today AndToDate:tomorrow];
  XCTAssert(isValid , @"Error Date Validation - From To after To date");
}

- (void)testDateValidationToDateBeforeFromDate {
  NSDate *today = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *tomorrow = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:today options:0];
  BOOL isValid = [DateValidationService validateFromDate:tomorrow AndToDate:today];
  XCTAssert(!isValid , @"Error Date Validation - To date before From date");
}

- (void)testDateValidationFromDateInPast {
  NSDate *today = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *yesterday = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:today options:0];
  BOOL isValid = [DateValidationService validateFromDateIsTodayOrLater:yesterday];
  XCTAssert(!isValid , @"Error Date Validation - From date in past");
}

- (void)testDateValidationFromDateInFuture {
  NSDate *today = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *tomorrow = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:today options:0];
  BOOL isValid = [DateValidationService validateFromDateIsTodayOrLater:tomorrow];
  XCTAssert(isValid , @"Error Date Validation - From date in future");
}

- (void)testDateValidationFromDateToday{
  NSDate *today = [NSDate date];
  BOOL isValid = [DateValidationService validateFromDateIsTodayOrLater:today];
  XCTAssert(isValid , @"Error Date Validation - From date today");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
