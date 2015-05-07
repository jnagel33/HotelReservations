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
  
  [self seedDataIfNeeded];
  
  return YES;
}

-(void)seedDataIfNeeded {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
    NSError *fetchError;
    NSArray *myHotels = [self.hotelService.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    NSLog(@"%lu", (unsigned long)myHotels.count);
  if (myHotels.count == 0) {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"seed" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSArray *hotels = jsonObject[@"Hotels"];
    for (NSDictionary *hotel in hotels) {
      Hotel *newHotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
      newHotel.name = hotel[@"name"];
      newHotel.location = hotel[@"location"];
      NSNumber *starsNum = hotel[@"stars"];
      newHotel.stars = starsNum.intValue;
      NSArray *rooms = hotel[@"rooms"];
      for (NSDictionary *room in rooms) {
        Room *newRoom = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
        NSNumber *number = room[@"number"];
        newRoom.number = number.intValue;
        NSNumber *beds = room[@"beds"];
        newRoom.beds = beds.intValue;
        NSNumber *rate = room[@"rate"];
        newRoom.rate = rate.intValue;
        newRoom.hotel = newHotel;
        if (newRoom.rate == 2) {
          
          Guest *newGuest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
          newGuest.firstName = [NSString stringWithFormat:@"User1"];
          newGuest.lastName = [NSString stringWithFormat:@"User1"];
          
          Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.hotelService.coreDataStack.managedObjectContext];
          reservation.startDate = [NSDate date];
          NSCalendar *cal = [NSCalendar currentCalendar];
          NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
          dateComponent.day = 1;
          NSDate *tomorrow = [cal dateByAddingComponents:dateComponent toDate:reservation.startDate options:0];
          
          reservation.endDate = tomorrow;
          
          
          reservation.room = newRoom;
          [newGuest addReservationsObject:reservation];
        }
      }
    }
    
    NSError *saveError;
    [self.hotelService.coreDataStack.managedObjectContext save:&error];
    if (saveError) {
      NSLog(@"%@", saveError.localizedDescription);
    }
  }
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
