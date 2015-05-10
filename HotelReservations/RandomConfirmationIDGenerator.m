//
//  RandomConfirmationIDGenerator.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/9/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "RandomConfirmationIDGenerator.h"

@implementation RandomConfirmationIDGenerator

+(NSString *) generateConfirmationID {
  NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  
  int stringLength = 10;
  
  NSMutableString *randomString = [NSMutableString stringWithCapacity: stringLength];
  
  for (NSUInteger i = 0U; i < stringLength; i++) {
    u_int32_t r = arc4random() % [letters length];
    unichar c = [letters characterAtIndex:r];
    [randomString appendFormat:@"%C", c];
  }
  
  return randomString;
}

@end
