//
//  AppDelegate.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/4/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "AppDelegate.h"
#import "HotelReservationsStyleKit.h"
#import "MainMenuTableViewController.h"
#import "Hotel.h"
#import "Room.h"
#import "Guest.h"
#import "Reservation.h"
#import "CoreDataStack.h"
#import "HotelService.h"


@interface AppDelegate ()

@property (readwrite,strong,nonatomic) HotelService *hotelService;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
  [self.window makeKeyAndVisible];
  
  [[UILabel appearance] setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:17.0]];
  
  CoreDataStack *coreDataStack = [[CoreDataStack alloc] init];
  self.hotelService = [[HotelService alloc] initWithCoreDataStack:coreDataStack];
  
  MainMenuTableViewController *mainVC = [[MainMenuTableViewController alloc]init];
  UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:mainVC];
  self.window.rootViewController = navController;
  self.window.tintColor = [HotelReservationsStyleKit blueDark];
  
  [self.hotelService.coreDataStack seedDataIfNeeded];
  
  return YES;
}

-(void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply {
  UIApplication *app= [UIApplication sharedApplication];
  __block UIBackgroundTaskIdentifier task = [app beginBackgroundTaskWithName:@"test" expirationHandler:^{
    [[UIApplication sharedApplication]endBackgroundTask:task];
    task = UIBackgroundTaskInvalid;
  }];
  
  NSArray *reservations = [self.hotelService fetchTodaysReservations];
  NSMutableArray *reservationArray = [[NSMutableArray alloc]init];
  for (int i = 0; i < reservations.count;i++) {
    Reservation *reservation = reservations[i];
    Guest *guest = reservation.guests.allObjects[0];
    NSString *fullNameStr = [NSString stringWithFormat:@"%@, %@", guest.lastName, guest.firstName];
    Room *room = reservation.room;
    NSNumber *roomNumber = [[NSNumber alloc]initWithInt:room.number];
    NSDictionary *reservationInfo = @{@"room": roomNumber, @"guest": fullNameStr};
    [reservationArray addObject:reservationInfo];
  }
  
  reply(@{@"reservations":reservationArray});
  
  
  [app endBackgroundTask:task];
  task = UIBackgroundTaskInvalid;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

- (void)saveContext {
  NSManagedObjectContext *managedObjectContext = self.hotelService.coreDataStack.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
