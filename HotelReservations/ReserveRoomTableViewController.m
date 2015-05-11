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
#import "GuestReservationsTableViewController.h"
#import "PickerHeaderViewCell.h"
#import "HotelService.h"
#import "GlobalConstants.h"

static const NSInteger kDetailsSection = 0;
static const NSInteger kDateSection = 1;
static const NSInteger kNameSection = 2;
static const NSInteger kGuestsSection = 3;
static const CGFloat kGuestSectionHeaderHeight = 30;
static const CGFloat kNormalSectionHeaderHeight = 15;
static const CGFloat kGuestPickerCellHeight = 209;
static const NSInteger kDetailSectionRowNums = 3;
static const NSInteger kDateSectionRowNums = 2;
static const NSInteger kNameSectionRowNums = 2;
static const NSInteger kGuestSectionRowNums = 2;
static const NSInteger kReserveButtonSectionRowNums = 1;
static const CGFloat kTableViewOffsetBuffer = 100;

@interface ReserveRoomTableViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property(strong,nonatomic)ReservationTableViewCell *hotelNameCell;
@property(strong,nonatomic)ReservationTableViewCell *roomNumberCell;
@property(strong,nonatomic)ReservationTableViewCell *roomRateCell;
@property(strong,nonatomic)ReservationTableViewCell *fromDateCell;
@property(strong,nonatomic)ReservationTableViewCell *toDateCell;
@property(strong,nonatomic)PickerHeaderViewCell *guestCell;
@property(strong,nonatomic)UITableViewCell *guestPickerCell;
@property(strong,nonatomic)UIPickerView *guestPicker;
@property(strong,nonatomic)GuestNameTableViewCell *firstNameCell;
@property(strong,nonatomic)GuestNameTableViewCell *lastNameCell;
@property(strong,nonatomic)ButtonTableViewCell *reserveRoomCell;
@property(nonatomic)BOOL showUsers;
@property(strong,nonatomic)NSArray *guests;
@property(nonatomic)CGFloat currentTableViewYOffset;

@end

@implementation ReserveRoomTableViewController

-(void)loadView {
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kTitleLabelWidth, kTitleLabelHeight)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.font = [UIFont fontWithName:kFontName size:kTitleFontSize];
  titleLabel.text = @"Make a Reservation";
  self.navigationItem.titleView = titleLabel;
  
  self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  self.hotelNameCell = [[ReservationTableViewCell alloc]init];
  self.roomNumberCell = [[ReservationTableViewCell alloc]init];
  self.roomRateCell = [[ReservationTableViewCell alloc]init];
  self.fromDateCell = [[ReservationTableViewCell alloc]init];
  self.toDateCell = [[ReservationTableViewCell alloc]init];
  self.firstNameCell = [[GuestNameTableViewCell alloc]init];
  self.lastNameCell = [[GuestNameTableViewCell alloc]init];
  self.reserveRoomCell = [[ButtonTableViewCell alloc]init];
  self.guestCell = [[PickerHeaderViewCell alloc]init];
  self.guestPickerCell = [[UITableViewCell alloc]init];
  self.guestPicker = [[UIPickerView alloc]init];
  self.guestPicker.translatesAutoresizingMaskIntoConstraints = false;
  [self.guestPickerCell addSubview:self.guestPicker];
  self.guestPickerCell.clipsToBounds = true;
  
  NSLayoutConstraint *userPickerCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.guestPicker attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.guestPickerCell attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.guestPickerCell addConstraint:userPickerCenterYLayoutConstraint];
  NSLayoutConstraint *userPickerCenterXLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.guestPicker attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.guestPickerCell attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  [self.guestPickerCell addConstraint:userPickerCenterXLayoutConstraint];
  
  NSLayoutConstraint *userPickerHeightLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.guestPicker attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.guestPickerCell attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
  [self.guestPickerCell addConstraint:userPickerHeightLayoutConstraint];
  
  NSLayoutConstraint *userPickerWidthLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.guestPicker attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.guestPickerCell attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
  [self.guestPickerCell addConstraint:userPickerWidthLayoutConstraint];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.tableView registerClass:[ReservationTableViewCell class] forCellReuseIdentifier:@"ReservationCell"];
  [self.tableView registerClass:[ButtonTableViewCell class] forCellReuseIdentifier:@"ReserveCell"];
  [self.tableView registerClass:[GuestNameTableViewCell class] forCellReuseIdentifier:@"GuestNameCell"];
  [self.tableView registerClass:[PickerHeaderViewCell class] forCellReuseIdentifier:@"UserPickerCell"];
  
  self.firstNameCell.nameTextField.delegate = self;
  self.lastNameCell.nameTextField.delegate = self;
  [self getGuestsForPicker];
  self.guestPicker.dataSource = self;
  self.guestPicker.delegate = self;
  
  self.showUsers = false;
  self.guestCell.detailLabel.text = @"--Choose a Guest--";
}

-(NSInteger)numberOfDaysForReservation {
  NSDate *fromDate;
  NSDate *toDate;
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:nil forDate:self.fromDate];
  [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:nil forDate:self.toDate];
  
  NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
  
  return [difference day];
}

-(void)getGuestsForPicker {
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  self.guests = [appDelegate.hotelService fetchAllGuests];
}

-(void)setUser {
  NSInteger currentRow = [self.guestPicker selectedRowInComponent:0];
  if (currentRow != 0) {
    Guest *guest = self.guests[currentRow - 1];
    NSString *nameStr = [NSString stringWithFormat:@"%@, %@", guest.lastName, guest.firstName];
    self.guestCell.detailLabel.text = nameStr;
  } else {
    self.guestCell.detailLabel.text = @"--Choose a Guest--";
  }
  if (self.showUsers) {
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + self.currentTableViewYOffset)];
    [UIView animateWithDuration:0.5 animations:^{
      [self.view layoutIfNeeded];
    }];
  }
}

//MARK:
//MARK: UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == kDetailsSection) {
    return kDetailSectionRowNums;
  } else if (section == kDateSection) {
    return kDateSectionRowNums;
  } else if (section == kNameSection) {
    return kNameSectionRowNums;
  }  else if (section == kGuestsSection) {
    return kGuestSectionRowNums;
  } else {
    return kReserveButtonSectionRowNums;
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
        self.roomRateCell.nameLabel.text = @"Cost:";
        long cost = [self numberOfDaysForReservation] * self.selectedRoom.rate;
        self.roomRateCell.detailLabel.text = [NSString stringWithFormat:@"$%ld @ $%hd / night", cost, self.selectedRoom.rate];
        return self.roomRateCell;
        break;
      default:
        return [[UITableViewCell alloc]init];
        break;
    }
  } else if (indexPath.section == kDateSection) {
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
  } else if (indexPath.section == kNameSection) {
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
  } else if (indexPath.section == kGuestsSection) {
    if (indexPath.row == 0) {
      if (self.guestCell == nil) {
        self.guestCell = [tableView dequeueReusableCellWithIdentifier:@"UserPickerCell" forIndexPath:indexPath];
        self.guestCell.infoLabel.text = @"User:";
      }
      return self.guestCell;
    } else {
      return self.guestPickerCell;
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
  [self setUser];
  if (indexPath.section == kNameSection) {
    if (indexPath.row == 0) {
      [self.firstNameCell.nameTextField becomeFirstResponder];
    } else {
      [self.lastNameCell.nameTextField becomeFirstResponder];
    }
  } else if (indexPath.section == kGuestsSection && indexPath.row == 0) {
    self.showUsers = !self.showUsers;
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + kTableViewOffsetBuffer)];
    [UIView animateWithDuration:0.5 animations:^{
      [self.view layoutIfNeeded];
    }];
    [self.tableView reloadData];
  } else if (indexPath.section == 4) {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    Guest *guest;
    NSInteger currentRow = [self.guestPicker selectedRowInComponent:0];
    if (currentRow != 0) {
      guest = self.guests[currentRow - 1];
    } else {
      if (self.firstNameCell.nameTextField != nil && self.lastNameCell.nameTextField != nil) {
        guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:appDelegate.hotelService.coreDataStack.managedObjectContext];
        guest.firstName = self.firstNameCell.nameTextField.text;
        guest.lastName = self.lastNameCell.nameTextField.text;
      }
    }
    [appDelegate.hotelService makeReservationForRoom:self.selectedRoom withFromDate:self.fromDate andToDate:self.toDate forGuest:guest];
    UINavigationController * navigationController = self.navigationController;
    [self.navigationController popToRootViewControllerAnimated:false];
    GuestReservationsTableViewController *guestReservationVC = [[GuestReservationsTableViewController alloc]init];
    guestReservationVC.selectedGuest = guest;
    [navigationController pushViewController:guestReservationVC animated:YES];
  }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == kGuestsSection && indexPath.row == 1) {
    if (self.showUsers) {
      return kGuestPickerCellHeight;
    } else {
      return 0;
    }
  }
  return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == kGuestsSection) {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *sectionLabel = [[UILabel alloc]init];
    sectionLabel.textColor = [UIColor grayColor];
    sectionLabel.translatesAutoresizingMaskIntoConstraints = false;
    sectionLabel.text = @"--Or Select an Existing Guest--";
    [headerView addSubview:sectionLabel];
    
    NSLayoutConstraint *sectionLabelCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:sectionLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [headerView addConstraint:sectionLabelCenterYLayoutConstraint];
    NSLayoutConstraint *sectionLabelCenterXLayoutConstraint = [NSLayoutConstraint constraintWithItem:sectionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [headerView addConstraint:sectionLabelCenterXLayoutConstraint];
    return headerView;
  }
  return [super tableView:tableView viewForHeaderInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == kGuestsSection) {
    return kGuestSectionHeaderHeight;
  }
  return kNormalSectionHeaderHeight;
}

//MARK UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  if (textField == self.firstNameCell.nameTextField) {
    [self.lastNameCell.nameTextField becomeFirstResponder];
  }
  return true;
}

//MARK:
//MARK: UIPickerViewDelagate

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return self.guests.count + 1;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  if (row == 0) {
    return @"Choose a Guest";
  }
  Guest *guest = self.guests[row - 1];
  return [NSString stringWithFormat:@"%@, %@", guest.lastName, guest.firstName];
}

@end
