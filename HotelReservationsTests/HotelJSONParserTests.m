//
//  HotelJSONParserTests.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/10/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HotelJSONParserService.h"
#import "CoreDataStack.h"
#import "HotelService.h"
#import <CoreData/CoreData.h>

@interface HotelJSONParserTests : XCTestCase

@property(strong,nonatomic)CoreDataStack *coreDataStack;
@property(strong,nonatomic)HotelService *hotelService;

@end

@implementation HotelJSONParserTests

- (void)setUp {
    [super setUp];
    self.coreDataStack = [[CoreDataStack alloc]initForTesting];
    self.hotelService = [[HotelService alloc]initWithCoreDataStack:self.coreDataStack];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
  [HotelJSONParserService parseJSONFromSeedFile:self.coreDataStack];
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  NSArray *hotels = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    XCTAssert(hotels.count == 4, @"Failed - JSON parser failed to seed the application");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
