//
//  CoreDataStack.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "CoreDataStack.h"
#import "Hotel.h"
#import "Room.h"
#import "Reservation.h"
#import "Guest.h"
#import <UIKit/UIKit.h>
#import "RandomConfirmationIDGenerator.h"
#import "HotelJSONParserService.h"

@interface CoreDataStack()

@property(nonatomic)BOOL isForTesting;

@end

@implementation CoreDataStack

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

-(instancetype)initForTesting {
  if (self = [super init]) {
    self.isForTesting = true;
  }
  return self;
}

-(instancetype)init {
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleWillChangeStore:) name:NSPersistentStoreCoordinatorStoresWillChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleDidChangeStore:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleChangesToData:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:nil];
  }
  return self;
}

-(void)handleWillChangeStore:(NSNotification *)notification {
  [self.managedObjectContext performBlock:^{
    if ([self.managedObjectContext hasChanges]) {
      NSError *error;
      [self.managedObjectContext save:&error];
      if (error != nil) {
        NSLog(@"%@", error.localizedDescription);
      }
    }
  }];
  [self.managedObjectContext reset];
}

-(void)handleDidChangeStore:(NSNotification *)notification {
}

-(void)handleChangesToData:(NSNotification *)notification {
  NSLog(@"Data changed");
  [self.managedObjectContext performBlock:^{
    [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    [self checkForDuplicates];
  }];
  [[NSNotificationCenter defaultCenter]postNotificationName:@"DataChanged" object:nil];
}

- (NSURL *)applicationDocumentsDirectory {
  // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jnagel.HotelReservations" in the application's documents directory.
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
  // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HotelReservations" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  // Create the coordinator and store
  
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HotelReservations.sqlite"];
  NSError *error = nil;
  NSString *storeType;
  NSString *failureReason = @"There was an error creating or loading the application's saved data.";
  if (self.isForTesting) {
    storeType = NSInMemoryStoreType;
  } else {
    storeType = NSSQLiteStoreType;
  }
  
  NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @true, NSInferMappingModelAutomaticallyOption : @true,NSPersistentStoreUbiquitousContentNameKey : @"ReservationsV2iCloud", NSPersistentStoreUbiquitousContentURLKey : [self cloudDirectory]};
  
  if (![_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil URL:storeURL options:options error:&error]) {
    // Report any error we got.
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    // Replace this with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
  // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (!coordinator) {
    return nil;
  }
  _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
  [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  return _managedObjectContext;
}

-(NSURL *)cloudDirectory
{
  NSFileManager *fileManager=[NSFileManager defaultManager];
  NSURL *cloudRootURL=[fileManager URLForUbiquityContainerIdentifier:nil];
  NSLog (@"cloudRootURL=%@",cloudRootURL);
  return cloudRootURL;
}

-(void)seedDataIfNeeded {
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  NSError *fetchError;
  NSArray *myHotels = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
  NSLog(@"%lu", (unsigned long)myHotels.count);
  if (myHotels.count == 0) {
    [HotelJSONParserService parseJSONFromSeedFile:self];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
    NSError *fetchError;
    myHotels = [self.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    Hotel *hotel1 = myHotels[0];
    UIImage *image1 = [UIImage imageNamed:@"hotel1"];
    hotel1.image = UIImageJPEGRepresentation(image1, 1);
    NSArray *hotel1Rooms = hotel1.rooms.allObjects;
    [hotel1Rooms enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      Room *room = obj;
      UIImage *image;
      if (idx == 0) {
        image = [UIImage imageNamed:@"hotel1bed1"];
      } else if (idx == 1) {
        image = [UIImage imageNamed:@"hotel2bed1"];
      } else if (idx == 2) {
        image = [UIImage imageNamed:@"hotel1bed2"];
      } else if (idx == 3) {
        image = [UIImage imageNamed:@"hotel2bed2"];
      } else {
        image = [UIImage imageNamed:@"hotel1bed3"];
      }
      room.image = UIImageJPEGRepresentation(image, 1);
    }];
    
    Hotel *hotel2 = myHotels[1];
    UIImage *image2 = [UIImage imageNamed:@"hotel2"];
    hotel2.image = UIImageJPEGRepresentation(image2, 1);
    NSArray *hotel2Rooms = hotel2.rooms.allObjects;
    [hotel2Rooms enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      Room *room = obj;
      UIImage *image;
      if (idx == 0) {
        image = [UIImage imageNamed:@"hotel1bed1"];
      } else if (idx == 1) {
        image = [UIImage imageNamed:@"hotel2bed1"];
      } else if (idx == 2) {
        image = [UIImage imageNamed:@"hotel1bed2"];
      } else if (idx == 3) {
        image = [UIImage imageNamed:@"hotel2bed2"];
      } else {
        image = [UIImage imageNamed:@"hotel2bed3"];
      }
      room.image = UIImageJPEGRepresentation(image, 1);
    }];
    Hotel *hotel3 = myHotels[2];
    UIImage *image3 = [UIImage imageNamed:@"hotel3"];
    hotel3.image = UIImageJPEGRepresentation(image3, 1);
    NSArray *hotel3Rooms = hotel3.rooms.allObjects;
    [hotel3Rooms enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      Room *room = obj;
      UIImage *image;
      if (idx == 0) {
        image = [UIImage imageNamed:@"hotel1bed1"];
      } else if (idx == 1) {
        image = [UIImage imageNamed:@"hotel2bed1"];
      } else if (idx == 2) {
        image = [UIImage imageNamed:@"hotel1bed2"];
      } else if (idx == 3) {
        image = [UIImage imageNamed:@"hotel2bed2"];
      } else {
        image = [UIImage imageNamed:@"hotel1bed3"];
      }
      room.image = UIImageJPEGRepresentation(image, 1);
    }];
    Hotel *hotel4 = myHotels[3];
    UIImage *image4 = [UIImage imageNamed:@"hotel4"];
    hotel4.image = UIImageJPEGRepresentation(image4, 1);
    NSArray *hotel4Rooms = hotel4.rooms.allObjects;
    [hotel4Rooms enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      Room *room = obj;
      UIImage *image;
      if (idx == 0) {
        image = [UIImage imageNamed:@"hotel1bed1"];
      } else if (idx == 1) {
        image = [UIImage imageNamed:@"hotel2bed1"];
      } else if (idx == 2) {
        image = [UIImage imageNamed:@"hotel1bed2"];
      } else if (idx == 3) {
        image = [UIImage imageNamed:@"hotel2bed2"];
      } else {
        image = [UIImage imageNamed:@"hotel2bed3"];
      }
      room.image = UIImageJPEGRepresentation(image, 1);
    }];
    
    NSError *saveError;
    [self.managedObjectContext save:&saveError];
    if (saveError) {
      NSLog(@"%@", saveError.localizedDescription);
    }
  }
}

-(void)checkForDuplicates {
  //Hotels
  NSString *uniqueHotelIdentifier = @"name";
  NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:uniqueHotelIdentifier];
  NSExpression *countExpression = [NSExpression expressionForFunction: @"count:" arguments:@[keyPathExpression]];
  NSExpressionDescription *countExpressionDescription = [[NSExpressionDescription alloc]init];
  [countExpressionDescription setName:@"count"];
  [countExpressionDescription setExpression:countExpression];
  [countExpressionDescription setExpressionResultType:NSInteger64AttributeType];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:self.managedObjectContext];
  NSAttributeDescription *uniqueAttribute = [[entity attributesByName]objectForKey:uniqueHotelIdentifier];
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  [fetchRequest setPropertiesToFetch:@[uniqueAttribute, countExpressionDescription]];
  [fetchRequest setPropertiesToGroupBy:@[uniqueAttribute]];
  [fetchRequest setResultType:NSDictionaryResultType];
  NSArray * fetchedDictionaries = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
  NSMutableArray *hotelsWithDupes = [NSMutableArray array];
  for (NSDictionary *dict in fetchedDictionaries) {
    NSNumber *count = dict[@"count"];
    if ([count integerValue] > 1) {
      [hotelsWithDupes addObject:dict[@"name"]];
    }
  }
  
  NSFetchRequest *dupeFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  [dupeFetchRequest setIncludesPendingChanges:false];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name IN (%@)", hotelsWithDupes];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true];
  [dupeFetchRequest setSortDescriptors:@[sortDescriptor]];
  [dupeFetchRequest setPredicate:predicate];
  NSArray *dupes = [self.managedObjectContext executeFetchRequest:dupeFetchRequest error:nil];
  
  
  Hotel *prevHotel;
  for (Hotel *duplicate in dupes) {
    if (prevHotel) {
      if ([duplicate.name isEqualToString:prevHotel.name]) {
        if (duplicate.createdTimeStamp > prevHotel.createdTimeStamp) {
          [self.managedObjectContext deleteObject:duplicate];
        } else {
          [self.managedObjectContext deleteObject:prevHotel];
          prevHotel = duplicate;
        }
      } else {
        prevHotel = duplicate;
      }
    } else {
      prevHotel = duplicate;
    }
  }  
  [self.managedObjectContext save:nil];
}


#pragma mark - Core Data Saving support

- (void)saveContext {
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
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
