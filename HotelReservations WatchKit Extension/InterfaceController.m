//
//  InterfaceController.m
//  HotelReservations WatchKit Extension
//
//  Created by Josh Nagel on 5/9/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
  [super awakeWithContext:context];
  
  [InterfaceController openParentApplication:@{@"request":@"reservation"} reply:^(NSDictionary *replyInfo, NSError *error) {
    NSArray *reservations = replyInfo[@"reservations"];
    for (NSDictionary *reservationInfo in reservations) {
      NSLog(@"%@", reservationInfo[@"hotel"]);
    }
  }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



