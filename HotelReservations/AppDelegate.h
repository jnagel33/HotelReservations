//
//  AppDelegate.h
//  HotelReservations
//
//  Created by Josh Nagel on 5/4/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class HotelService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) HotelService *hotelService;

@end

