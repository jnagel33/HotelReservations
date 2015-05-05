//
//  Room.h
//  
//
//  Created by Josh Nagel on 5/4/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hotel;

@interface Room : NSManagedObject

@property (nonatomic) int16_t beds;
@property (nonatomic) int16_t number;
@property (nonatomic) int16_t rate;
@property (nonatomic, retain) Hotel *hotel;

@end
