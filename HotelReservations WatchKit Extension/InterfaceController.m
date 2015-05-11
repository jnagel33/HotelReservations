//
//  InterfaceController.m
//  HotelReservations WatchKit Extension
//
//  Created by Josh Nagel on 5/9/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "InterfaceController.h"
#import "ReservationRow.h"
#import "ImageResizer.h"
#import "HotelReservationsStyleKit.h"


@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;
@property (weak, nonatomic) IBOutlet WKInterfaceGroup *headerGroup;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *headerTitleLabel;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
  [super awakeWithContext:context];
  

  [self.headerGroup setBackgroundImage:[HotelReservationsStyleKit imageOfSectionHeaderWithFrame:CGRectMake(0, 0, 40, 40)]];
  [self.headerTitleLabel setText:@"Reservations"];
  
  [InterfaceController openParentApplication:@{@"request":@"reservation"} reply:^(NSDictionary *replyInfo, NSError *error) {
    NSArray *reservations = replyInfo[@"reservations"];
    [self.table setNumberOfRows:reservations.count withRowType:@"ReservationRow"];
    
    for (NSDictionary *reservationInfo in reservations) {
      NSUInteger index = [reservations indexOfObject:reservationInfo];
      ReservationRow *row = [self.table rowControllerAtIndex:index];
      NSString *hotelName = reservationInfo[@"hotel"];
      NSNumber *roomNumber = reservationInfo[@"room"];
      row.hotelAndRoomLabel.text = [NSString stringWithFormat:@"%@ - #%@",hotelName, roomNumber];
      row.guestLabel.text = reservationInfo[@"guest"];
      NSData *roomImageData = reservationInfo[@"image"];
      UIImage *image = [UIImage imageWithData:roomImageData];
      UIImage *resizedImage = [ImageResizer resizeImage:image withSize:CGSizeMake(90, 90)];
      [row.roomImageView setImage:resizedImage];
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



