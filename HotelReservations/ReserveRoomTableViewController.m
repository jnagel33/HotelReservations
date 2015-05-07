//
//  ReserveRoomTableViewController.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "ReserveRoomTableViewController.h"
#import "ReservationTableViewCell.h"
#import "Room.h"
#import "Hotel.h"
#import "ButtonTableViewCell.h"
#import "HotelReservationsStyleKit.h"
#import "GuestNameTableViewCell.h"
#import "AppDelegate.h"
#import "HotelService.h"
#import "Guest.h"

@interface ReserveRoomTableViewController () <UITextFieldDelegate>

@property(strong,nonatomic)ReservationTableViewCell *hotelNameCell;
@property(strong,nonatomic)ReservationTableViewCell *roomNumberCell;
@property(strong,nonatomic)ReservationTableViewCell *roomRateCell;
@property(strong,nonatomic)ReservationTableViewCell *fromDateCell;
@property(strong,nonatomic)ReservationTableViewCell *toDateCell;
@property(strong,nonatomic)GuestNameTableViewCell *firstNameCell;
@property(strong,nonatomic)GuestNameTableViewCell *lastNameCell;
@property(strong,nonatomic)ButtonTableViewCell *reserveRoomCell;

@end

@implementation ReserveRoomTableViewController

-(void)loadView {
  self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  self.hotelNameCell = [[ReservationTableViewCell alloc]init];
  self.roomNumberCell = [[ReservationTableViewCell alloc]init];
  self.roomRateCell = [[ReservationTableViewCell alloc]init];
  self.fromDateCell = [[ReservationTableViewCell alloc]init];
  self.toDateCell = [[ReservationTableViewCell alloc]init];
  self.firstNameCell = [[GuestNameTableViewCell alloc]init];
  self.lastNameCell = [[GuestNameTableViewCell alloc]init];
  self.reserveRoomCell = [[ButtonTableViewCell alloc]init];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:22];
  titleLabel.text = @"Make a Reservation";
  self.navigationItem.titleView = titleLabel;
  
  
  [self.tableView registerClass:[ReservationTableViewCell class] forCellReuseIdentifier:@"ReservationCell"];
  [self.tableView registerClass:[ButtonTableViewCell class] forCellReuseIdentifier:@"ReserveCell"];
  [self.tableView registerClass:[GuestNameTableViewCell class] forCellReuseIdentifier:@"GuestNameCell"];
  self.firstNameCell.nameTextField.delegate = self;
  self.lastNameCell.nameTextField.delegate = self;
}

//MARK:
//MARK: UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 3;
  } else if (section == 1) {
    return 2;
  } else if (section == 2) {
    return 2;
  } else {
    return 1;
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.section == 0) {
    switch (indexPath.row) {
      case 0:
        if (self.hotelNameCell == nil) {
          self.hotelNameCell = [self.hotelNameCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReservationCell"];
        }
        self.hotelNameCell.nameLabel.text = @"Hotel:";
        self.hotelNameCell.detailLabel.text = self.selectedRoom.hotel.name;
        return self.hotelNameCell;
        break;
      case 1:
        if (self.roomNumberCell == nil) {
          self.roomNumberCell = [self.roomNumberCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReservationCell"];
        }
        self.roomNumberCell.nameLabel.text = @"Room #:";
        self.roomNumberCell.detailLabel.text = [NSString stringWithFormat:@"%hd",self.selectedRoom.number];
        return self.roomNumberCell;
        break;
      case 2:
        if (self.roomRateCell == nil) {
          self.roomRateCell = [self.roomRateCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReservationCell"];
        }
        self.roomRateCell.nameLabel.text = @"Rate:";
        self.roomRateCell.detailLabel.text = [NSString stringWithFormat:@"$%hd",self.selectedRoom.rate];
        return self.roomRateCell;
        break;
      default:
        return [[UITableViewCell alloc]init];
        break;
    }
  } else if (indexPath.section == 1) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"EEEE, MMMM dd";
    switch (indexPath.row) {
      case 0:
        if (self.fromDateCell == nil) {
          self.fromDateCell = [self.fromDateCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReservationCell"];
        }
        self.fromDateCell.nameLabel.text = @"From:";
        self.fromDateCell.detailLabel.text = [dateFormatter stringFromDate:self.fromDate];
        return self.fromDateCell;
        break;
      case 1:
        if (self.toDateCell == nil) {
          self.toDateCell = [self.toDateCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReservationCell"];
        }
        self.toDateCell.nameLabel.text = @"To:";
        self.toDateCell.detailLabel.text = [dateFormatter stringFromDate:self.toDate];
        return self.toDateCell;
        break;
      default:
        return [[UITableViewCell alloc]init];
        break;
    }
  } else if (indexPath.section == 2){
    if (indexPath.row == 0) {
      if (self.firstNameCell == nil) {
        self.firstNameCell = [self.firstNameCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GuestNameCell"];
      }
      self.firstNameCell.nameLabel.text = @"First Name:";
      self.firstNameCell.nameTextField.placeholder = @"Enter your first name";
      return self.firstNameCell;
    } else {
      if (self.lastNameCell == nil) {
        self.lastNameCell = [self.lastNameCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GuestNameCell"];
      }
      self.lastNameCell.nameLabel.text = @"Last Name:";
      self.lastNameCell.nameTextField.placeholder = @"Enter your last name";
      return self.lastNameCell;
    }
  } else {
    if (self.reserveRoomCell == nil) {
      self.reserveRoomCell = [self.reserveRoomCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReserveCell"];
    }
    self.reserveRoomCell.searchLabel.text = @"Reserve";
    return self.reserveRoomCell;
  }
}

//MARK:
//MARK: UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:true];
  if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      [self.firstNameCell.nameTextField becomeFirstResponder];
    } else {
      [self.lastNameCell.nameTextField becomeFirstResponder];
    }
  } else if (indexPath.section == 3) {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  Guest *guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:appDelegate.hotelService.coreDataStack.managedObjectContext];
    guest.firstName = self.firstNameCell.nameTextField.text;
    guest.lastName = self.lastNameCell.nameTextField.text;
    [appDelegate.hotelService makeReservationForRoom:self.selectedRoom withFromDate:self.fromDate andToDate:self.toDate forGuest:guest];
  }
}

//MARK UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  if (textField == self.firstNameCell.nameTextField) {
    [self.lastNameCell.nameTextField becomeFirstResponder];
  }
  return true;
}



@end
