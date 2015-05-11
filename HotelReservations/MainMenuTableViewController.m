//
//  MainMenuTableViewController.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/5/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "MainMenuTableViewController.h"
#import "PickerHeaderViewCell.h"
#import "HotelListViewController.h"
#import "ButtonTableViewCell.h"
#import "AvailabilityTableViewController.h"
#import "HotelHeaderView.h"
#import "HotelReservationsStyleKit.h"
#import "NumberOfBedsTableViewCell.h"
#import "GuestTableViewController.h"
#import "DateValidationService.h"
#import "Hotel.h"
#import "HotelService.h"
#import "AppDelegate.h"
#import "HotelReservationsStyleKit.h"
#import "GlobalConstants.h"

static const NSInteger kMaxBedsCount = 3;
static const NSInteger kMinBedsCount = 1;
static const double kAnimationDuration = 0.4;
static const NSInteger kReservationSearchSection = 0;
static const NSInteger kReservationsearchSectionRowNums = 8;
static const NSInteger kSearchHotelsAndGuestsSection = 1;
static const NSInteger kSearchHotelsAndGuestsSectionRowNums = 2;
static const NSInteger kFromDateCellRow = 0;
static const NSInteger kFromDateCellPickerRow = 1;
static const NSInteger kToDateCellRow = 2;
static const NSInteger kToDateCellPickerRow = 3;
static const NSInteger kLocationCellRow = 4;
static const NSInteger kLocationCellPickerRow = 5;
static const NSInteger kNumberOfBedsCellRow = 6;
static const NSInteger kSearchButtonCellRow = 7;
static const NSInteger kSearchHotelsCellRow = 0;
static const NSInteger kSearchGuestsCellRow = 1;
static const CGFloat kDatePickerHeight = 219;
static const CGFloat kLocationPickerHeight = 140;
static const NSInteger kNumberOfSections = 2;

@interface MainMenuTableViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property(strong,nonatomic)PickerHeaderViewCell *fromCell;
@property(strong,nonatomic)PickerHeaderViewCell *toCell;
@property(strong,nonatomic)UITableViewCell *fromDateCell;
@property(strong,nonatomic)UITableViewCell *toDateCell;
@property(strong,nonatomic)UITableViewCell *searchHotelsCell;
@property(strong,nonatomic)UITableViewCell *searchCustomersCell;
@property(strong,nonatomic)ButtonTableViewCell *searchButtonCell;
@property(strong,nonatomic)NumberOfBedsTableViewCell *numberOfBedsCell;
@property(strong,nonatomic)PickerHeaderViewCell *locationCell;
@property(strong,nonatomic)UITableViewCell *locationPickerCell;
@property(strong,nonatomic)UIPickerView *locationPicker;
@property(strong, nonatomic)UIDatePicker *fromDatePicker;
@property(strong, nonatomic)UIDatePicker *toDatePicker;
@property(nonatomic)BOOL showFromDate;
@property(nonatomic)BOOL showToDate;
@property(nonatomic)BOOL showLocation;
@property(strong,nonatomic)NSDateFormatter *dateFormatter;
@property(nonatomic)int16_t bedCount;
@property(strong,nonatomic)NSMutableArray *locations;

@end

@implementation MainMenuTableViewController

-(void)loadView {
  self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  self.fromCell = [[PickerHeaderViewCell alloc]init];
  self.toCell = [[PickerHeaderViewCell alloc]init];
  self.fromDateCell = [[UITableViewCell alloc]init];
  self.fromDatePicker = [[UIDatePicker alloc]init];
  self.fromDatePicker.translatesAutoresizingMaskIntoConstraints = false;
  [self.fromDateCell addSubview:self.fromDatePicker];
  self.fromDateCell.clipsToBounds = true;
  self.toDateCell = [[UITableViewCell alloc]init];
  self.toDatePicker = [[UIDatePicker alloc]init];
  self.toDatePicker.translatesAutoresizingMaskIntoConstraints = false;
  [self.toDateCell addSubview:self.toDatePicker];
  self.toDateCell.clipsToBounds = true;
  self.searchHotelsCell = [[UITableViewCell alloc]init];
  self.searchHotelsCell.textLabel.text = @"Search Hotels";
  [self.searchHotelsCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  self.searchCustomersCell = [[UITableViewCell alloc]init];
  self.searchCustomersCell.textLabel.text = @"Search Guests";
  [self.searchCustomersCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  self.searchButtonCell = [[ButtonTableViewCell alloc]init];
  self.numberOfBedsCell = [[NumberOfBedsTableViewCell alloc]init];
  self.locationPickerCell = [[UITableViewCell alloc]init];
  self.locationPicker = [[UIPickerView alloc]init];
  self.locationPicker.translatesAutoresizingMaskIntoConstraints = false;
  [self.locationPickerCell addSubview:self.locationPicker];
  self.locationPickerCell.clipsToBounds = true;
  self.locationCell = [[PickerHeaderViewCell alloc]init];
  [self setupConstraints];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kTitleLabelWidth, kTitleLabelHeight)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.font = [UIFont fontWithName:kFontName size:kTitleFontSize];
  titleLabel.text = @"Main Menu";
  
  self.navigationItem.titleView = titleLabel;
  
  self.fromDatePicker.datePickerMode = UIDatePickerModeDate;
  self.toDatePicker.datePickerMode = UIDatePickerModeDate;
  self.dateFormatter = [[NSDateFormatter alloc]init];
  self.dateFormatter.dateFormat = @"EEEE, MMMM dd";
  [self.tableView registerClass:[PickerHeaderViewCell class]forCellReuseIdentifier:@"DatePickerHeaderViewCell"];
  [self.tableView registerClass:[PickerHeaderViewCell class]forCellReuseIdentifier:@"LocationPickerHeaderViewCell"];
  [self.tableView registerClass:[ButtonTableViewCell class]forCellReuseIdentifier:@"SearchButtonCell"];
  [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"SearchCell"];
  [self.tableView registerClass:[NumberOfBedsTableViewCell class] forCellReuseIdentifier:@"NumberBedsCell"];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.showFromDate = false;
  self.showToDate = false;
  self.showLocation = false;
  self.bedCount = kMinBedsCount;
  
  [self refreshLocations];
  self.fromCell.detailLabel.text = @"--Choose a Date";
  self.toCell.detailLabel.text = @"--Choose a Date";
  self.locationCell.detailLabel.text = @"--Choose a Location--";
  self.locationPicker.delegate = self;
  self.locationPicker.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLocations) name:@"DataChanged" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)refreshLocations {
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  NSArray *hotels = [appDelegate.hotelService fetchAllHotels];
  self.locations = [[NSMutableArray alloc]init];
  for (Hotel *hotel in hotels) {
    [self.locations addObject:hotel.location];
  }
  [self.locationPicker reloadComponent:0];
}

-(void)toggleFromDatePicker:(BOOL)value {
  if (value) {
    self.showFromDate = false;
  } else {
    self.showFromDate = !self.showFromDate;
  }
  self.fromDatePicker.alpha = 0;
  [UIView animateWithDuration:kAnimationDuration animations:^{
    self.fromDatePicker.alpha = 1;
    [self.tableView reloadData];
  }];
}

-(void)toggleToDatePickerOrSetWith:(BOOL)value {
  if (value) {
    self.showToDate = false;
  } else {
    self.showToDate = !self.showToDate;
  }
  self.toDatePicker.alpha = 0;
  [UIView animateWithDuration:kAnimationDuration animations:^{
    self.toDatePicker.alpha = 1;
    [self.tableView reloadData];
  }];
}

-(void)toggleToLocationPickerOrSetWith:(BOOL)value {
  if (value) {
    self.showLocation = false;
  } else {
    self.showLocation = !self.showLocation;
  }
    [self.tableView reloadData];
}

-(void)plusMinusPressed:(UIButton *)sender {
  if (sender == self.numberOfBedsCell.plusButton) {
    self.bedCount++;
  } else {
    self.bedCount--;
  }
  if (self.bedCount > kMaxBedsCount){
    self.bedCount = kMaxBedsCount;
  } else if (self.bedCount < kMinBedsCount) {
    self.bedCount = kMinBedsCount;
  }
  self.numberOfBedsCell.bedsLabel.text = [NSString stringWithFormat:@"%ld+ Bed(s)", (long)self.bedCount];
}

-(void)setDates {
  self.fromCell.detailLabel.textColor = [HotelReservationsStyleKit blueDark];
  self.toCell.detailLabel.textColor = [HotelReservationsStyleKit blueDark];
  if ([DateValidationService validateFromDateIsTodayOrLater:self.fromDatePicker.date]) {
    NSString *fromDateStr = [self.dateFormatter stringFromDate:self.fromDatePicker.date];
    self.fromCell.detailLabel.text = fromDateStr;
  } else {
    self.fromCell.detailLabel.text = @"Date cannot be in the past";
    self.fromCell.detailLabel.textColor = [UIColor redColor];
  }
  NSString *toDateStr = [self.dateFormatter stringFromDate:self.toDatePicker.date];
  self.toCell.detailLabel.text = toDateStr;
}

-(void)setLocation {
  NSInteger currentRow = [self.locationPicker selectedRowInComponent:0];
  if (currentRow != 0) {
    self.locationCell.detailLabel.text = self.locations[currentRow - 1];
  } else {
    self.locationCell.detailLabel.text = @"--Choose a Location--";
  }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == kReservationSearchSection) {
    return kReservationsearchSectionRowNums;
  } else {
    return kSearchHotelsAndGuestsSectionRowNums;
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case kReservationSearchSection:
      switch (indexPath.row) {
        case kFromDateCellRow:
          if (self.fromCell == nil) {
            self.fromCell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerHeaderViewCell" forIndexPath:indexPath];
            self.fromCell.detailLabel.text = @"--Choose a Date--";
          }
          self.fromCell.infoLabel.text = @"From:";
          return self.fromCell;
          break;
        case kFromDateCellPickerRow:
          return self.fromDateCell;
          break;
        case kToDateCellRow:
          if (self.toCell == nil) {
            self.toCell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerHeaderViewCell" forIndexPath:indexPath];
            self.toCell.detailLabel.text = @"--Choose a Date--";
          }
          self.toCell.infoLabel.text = @"To:";
          return self.toCell;
          break;
        case kToDateCellPickerRow:
          return self.toDateCell;
          break;
        case kLocationCellRow:
          if (self.locationCell == nil) {
            self.locationCell = [tableView dequeueReusableCellWithIdentifier:@"LocationPickerHeaderViewCell" forIndexPath:indexPath];
            self.locationCell.detailLabel.text = @"--Choose a Location--";
          }
          self.locationCell.infoLabel.text = @"Location:";
          return self.locationCell;
          break;
        case kLocationCellPickerRow:
          return self.locationPickerCell;
          break;
        case kNumberOfBedsCellRow:
          if (self.numberOfBedsCell == nil) {
            self.numberOfBedsCell = [self.numberOfBedsCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NumberBedsCell"];
          }
          [self.numberOfBedsCell.plusButton addTarget:self action:@selector(plusMinusPressed:) forControlEvents:UIControlEventTouchUpInside];
          [self.numberOfBedsCell.minusButton addTarget:self action:@selector(plusMinusPressed:) forControlEvents:UIControlEventTouchUpInside];
          return self.numberOfBedsCell;
          break;
        case kSearchButtonCellRow:
          if (self.searchButtonCell == nil) {
            self.searchButtonCell = [self.searchButtonCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchButtonCell"];
          }
          return self.searchButtonCell;
          break;
        default:
          return [[UITableViewCell alloc]init];
          break;
      }
      break;
    case kSearchHotelsAndGuestsSection:
      switch (indexPath.row) {
        case kSearchHotelsCellRow:
          return self.searchHotelsCell;
          break;
        case kSearchGuestsCellRow:
          return self.searchCustomersCell;
          break;
        default:
          break;
      }
      
    default:
      return [[UITableViewCell alloc]init];
      break;
  }
}

#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return kNumberOfSections;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == kReservationSearchSection && indexPath.row == kFromDateCellPickerRow) {
    if (self.showFromDate) {
      return kDatePickerHeight;
    } else {
      return 0;
    }
  } else if (indexPath.section == kReservationSearchSection && indexPath.row == kToDateCellPickerRow) {
    if (self.showToDate) {
      return kDatePickerHeight;
    } else {
      return 0;
    }
  } else if (indexPath.section == kReservationSearchSection && indexPath.row == kLocationCellPickerRow) {
    if (self.showLocation) {
      return kLocationPickerHeight;
    } else {
      return 0;
    }
  } else {
    return self.tableView.rowHeight;
  }
  return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:true];
  if (indexPath.section == kReservationSearchSection) {
    [self setDates];
    [self setLocation];
    if (indexPath.row == kFromDateCellRow) {
      if (self.showToDate) {
        [self toggleToDatePickerOrSetWith:false];
      } else if (self.showLocation) {
        [self toggleToLocationPickerOrSetWith:false];
      }
      [self toggleFromDatePicker:false];
    } else if (indexPath.row == kToDateCellRow) {
      if (self.showFromDate) {
        [self toggleFromDatePicker:false];
      } else if (self.showLocation) {
        [self toggleToLocationPickerOrSetWith:false];
      }
      [self toggleToDatePickerOrSetWith:nil];
    } else if (indexPath.row == kLocationCellRow || indexPath.row == kLocationCellPickerRow || indexPath.row == kNumberOfBedsCellRow || indexPath.row == kSearchButtonCellRow) {
      [self toggleFromDatePicker:true];
      [self toggleToDatePickerOrSetWith:true];
      if (indexPath.row == kLocationCellRow) {
        self.showLocation = !self.showLocation;
        [self.tableView reloadData];
      }
      if (indexPath.row == kSearchButtonCellRow) {
        if ([DateValidationService validateFromDateIsTodayOrLater:self.fromDatePicker.date]) {
          if ([DateValidationService validateFromDate:self.fromDatePicker.date AndToDate:self.toDatePicker.date]) {
            AvailabilityTableViewController *availabilityVC = [[AvailabilityTableViewController alloc]init];
            availabilityVC.fromDate = self.fromDatePicker.date;
            availabilityVC.toDate = self.toDatePicker.date;
            availabilityVC.bedCount = self.bedCount;
            NSInteger currentRow = [self.locationPicker selectedRowInComponent:0];
            if (currentRow != 0) {
              availabilityVC.location = self.locations[currentRow - 1];
            }
            [self.navigationController pushViewController:availabilityVC animated:true];
          } else {
            self.toCell.detailLabel.text = @"To Date must be after From Date";
            self.toCell.detailLabel.textColor = [UIColor redColor];
          }
        }
      }
    }
  } else if (indexPath.section == kSearchHotelsAndGuestsSection) {
    if (indexPath.row == kSearchHotelsCellRow) {
      HotelListViewController *hotelListVC = [[HotelListViewController alloc]init];
      [self.navigationController pushViewController:hotelListVC animated:true];
    } else if (indexPath.row == kSearchGuestsCellRow) {
      GuestTableViewController *guestListVC = [[GuestTableViewController alloc]init];
      [self.navigationController pushViewController:guestListVC animated:true];
    }
  }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == kReservationSearchSection) {
    return @"Reservation";
  } else if (section == 1) {
    return @"Search";
  } else {
    return @"";
  }
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return self.locations.count + 1;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  if (row == 0) {
    return @"--Choose a Location--";
  }
  return self.locations[row - 1];
}

#pragma mark - Constraints

-(void)setupConstraints {
  NSLayoutConstraint *fromDatePickerYLayoutContraint = [NSLayoutConstraint constraintWithItem:self.fromDatePicker attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.fromDateCell attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.fromDateCell addConstraint:fromDatePickerYLayoutContraint];
  
  NSLayoutConstraint *fromDatePickerXLayoutContraint = [NSLayoutConstraint constraintWithItem:self.fromDatePicker attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.fromDateCell attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  [self.fromDateCell addConstraint:fromDatePickerXLayoutContraint];
  
  NSLayoutConstraint *fromDatePickerHeightLayoutContraint = [NSLayoutConstraint constraintWithItem:self.fromDatePicker attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.fromDateCell attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
  [self.fromDateCell addConstraint:fromDatePickerHeightLayoutContraint];
  
  NSLayoutConstraint *fromDatePickerWidthLayoutContraint = [NSLayoutConstraint constraintWithItem:self.fromDatePicker attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.fromDateCell attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
  [self.fromDateCell addConstraint:fromDatePickerWidthLayoutContraint];
  
  NSLayoutConstraint *toDatePickerYLayoutContraint = [NSLayoutConstraint constraintWithItem:self.toDatePicker attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.toDateCell attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.toDateCell addConstraint:toDatePickerYLayoutContraint];
  
  NSLayoutConstraint *toDatePickerXLayoutContraint = [NSLayoutConstraint constraintWithItem:self.toDatePicker attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.toDateCell attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  [self.toDateCell addConstraint:toDatePickerXLayoutContraint];
  
  NSLayoutConstraint *toDatePickerHeightLayoutContraint = [NSLayoutConstraint constraintWithItem:self.toDatePicker attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.toDateCell attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
  [self.toDateCell addConstraint:toDatePickerHeightLayoutContraint];
  
  NSLayoutConstraint *toDatePickerWidthLayoutContraint = [NSLayoutConstraint constraintWithItem:self.toDatePicker attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.toDateCell attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
  [self.toDateCell addConstraint:toDatePickerWidthLayoutContraint];
  
  NSLayoutConstraint *locationPickerYLayoutContraint = [NSLayoutConstraint constraintWithItem:self.locationPicker attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.locationPickerCell attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.locationPickerCell addConstraint:locationPickerYLayoutContraint];
  
  NSLayoutConstraint *locationPickerXLayoutContraint = [NSLayoutConstraint constraintWithItem:self.locationPicker attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.locationPickerCell attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  [self.locationPickerCell addConstraint:locationPickerXLayoutContraint];
  
  NSLayoutConstraint *locationPickerHeightLayoutContraint = [NSLayoutConstraint constraintWithItem:self.locationPicker attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.locationPickerCell attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
  [self.locationPickerCell addConstraint:locationPickerHeightLayoutContraint];
  
  NSLayoutConstraint *locationPickerWidthLayoutContraint = [NSLayoutConstraint constraintWithItem:self.locationPicker attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.locationPickerCell attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
  [self.locationPickerCell addConstraint:locationPickerWidthLayoutContraint];
}

@end
