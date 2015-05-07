//
//  MainMenuTableViewController.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/5/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "MainMenuTableViewController.h"
#import "DateTableViewCell.h"
#import "HotelListViewController.h"
#import "ButtonTableViewCell.h"
#import "AvailabilityTableViewController.h"
#import "HotelHeaderView.h"
#import "HotelReservationsStyleKit.h"
#import "NumberOfBedsTableViewCell.h"
#import "GuestTableViewController.h"

const NSInteger kMaxBedsCount = 3;
const NSInteger kMinBedsCount = 1;


@interface MainMenuTableViewController ()

@property(strong,nonatomic)DateTableViewCell *fromCell;
@property(strong,nonatomic)DateTableViewCell *toCell;
@property(strong,nonatomic)UITableViewCell *fromDateCell;
@property(strong,nonatomic)UITableViewCell *toDateCell;
@property(strong,nonatomic)UITableViewCell *searchHotelsCell;
@property(strong,nonatomic)UITableViewCell *searchCustomersCell;
@property(strong,nonatomic)ButtonTableViewCell *searchButtonCell;
@property(strong,nonatomic)NumberOfBedsTableViewCell *numberOfBedsCell;
@property(strong, nonatomic)UIDatePicker *fromDatePicker;
@property(strong, nonatomic)UIDatePicker *toDatePicker;
@property(nonatomic)BOOL showFromDate;
@property(nonatomic)BOOL showToDate;
@property(strong,nonatomic)NSDateFormatter *dateFormatter;
@property(nonatomic)int16_t bedCount;

@end

@implementation MainMenuTableViewController

-(void)loadView {
  self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  self.fromCell = [[DateTableViewCell alloc]init];
  self.toCell = [[DateTableViewCell alloc]init];
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
  self.searchCustomersCell.textLabel.text = @"Search Customers";
  [self.searchCustomersCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  self.searchButtonCell = [[ButtonTableViewCell alloc]init];
  
  self.numberOfBedsCell = [[NumberOfBedsTableViewCell alloc]init];
  
  [self setupConstraints];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.text = @"Main Menu";
  
  self.navigationItem.titleView = titleLabel;
  
  self.fromDatePicker.datePickerMode = UIDatePickerModeDate;
  self.toDatePicker.datePickerMode = UIDatePickerModeDate;
  self.dateFormatter = [[NSDateFormatter alloc]init];
  self.dateFormatter.dateFormat = @"EEEE, MMMM dd";
  [self.tableView registerClass:[DateTableViewCell class]forCellReuseIdentifier:@"FromToCell"];
  [self.tableView registerClass:[ButtonTableViewCell class]forCellReuseIdentifier:@"SearchButtonCell"];
  [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"SearchCell"];
  [self.tableView registerClass:[NumberOfBedsTableViewCell class] forCellReuseIdentifier:@"NumberBedsCell"];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.showFromDate = false;
  self.showToDate = false;
  self.bedCount = 1;
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
  NSString *fromDateStr = [self.dateFormatter stringFromDate:self.fromDatePicker.date];
  self.fromCell.dateLabel.text = fromDateStr;
  NSString *toDateStr = [self.dateFormatter stringFromDate:self.toDatePicker.date];
  self.toCell.dateLabel.text = toDateStr;
}

//MARK:
//MARK: UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 6;
  } else {
    return 2;
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0:
      switch (indexPath.row) {
        case 0:
          if (self.fromCell == nil) {
            self.fromCell = [self.fromCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FromToCell"];
          }
          self.fromCell.fromToLabel.text = @"From:";
          return self.fromCell;
          break;
        case 1:
          return self.fromDateCell;
          break;
        case 2:
          if (self.toCell == nil) {
            self.toCell = [self.toCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FromToCell"];
          }
          self.toCell.fromToLabel.text = @"To:";
          return self.toCell;
          break;
        case 3:
          return self.toDateCell;
          break;
        case 4:
          if (self.numberOfBedsCell == nil) {
            self.numberOfBedsCell = [self.numberOfBedsCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NumberBedsCell"];
          }
          [self.numberOfBedsCell.plusButton addTarget:self action:@selector(plusMinusPressed:) forControlEvents:UIControlEventTouchUpInside];
          [self.numberOfBedsCell.minusButton addTarget:self action:@selector(plusMinusPressed:) forControlEvents:UIControlEventTouchUpInside];
          return self.numberOfBedsCell;
          break;
        case 5:
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
    case 1:
      switch (indexPath.row) {
        case 0:
          return self.searchHotelsCell;
          break;
        case 1:
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

//MARK:
//MARK: UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && indexPath.row == 1) {
    if (self.showFromDate) {
      return 219;
    } else {
      return 0;
    }
  } else if (indexPath.section == 0 && indexPath.row == 3) {
    if (self.showToDate) {
      return 219;
    } else {
      return 0;
    }
  } else {
    return self.tableView.rowHeight;
  }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:true];
  if (indexPath.section == 0) {
    [self setDates];
    if (indexPath.row == 0) {
      if (self.showToDate) {
        self.showToDate = !self.showToDate;
        self.toDatePicker.alpha = 0;
        [UIView animateWithDuration:0.4 animations:^{
          self.toDatePicker.alpha = 1;
          [self.tableView reloadData];
        }];
      }
      self.showFromDate = !self.showFromDate;
      self.fromDatePicker.alpha = 0;
      [UIView animateWithDuration:0.4 animations:^{
        self.fromDatePicker.alpha = 1;
        [self.tableView reloadData];
      }];
    } else if (indexPath.row == 2) {
      if (self.showFromDate) {
        self.showFromDate = !self.showFromDate;
        self.fromDatePicker.alpha = 0;
        [UIView animateWithDuration:0.4 animations:^{
          self.fromDatePicker.alpha = 1;
          [self.tableView reloadData];
        }];
      }
      self.showToDate = !self.showToDate;
      self.toDatePicker.alpha = 0;
      [UIView animateWithDuration:0.4 animations:^{
        self.toDatePicker.alpha = 1;
        [self.tableView reloadData];
      }];
    } else if (indexPath.row == 5) {
      self.showFromDate = false;
      self.showToDate = false;
      AvailabilityTableViewController *availabilityVC = [[AvailabilityTableViewController alloc]init];
      availabilityVC.fromDate = self.fromDatePicker.date;
      availabilityVC.toDate = self.toDatePicker.date;
      availabilityVC.bedCount = self.bedCount;
      [self.navigationController pushViewController:availabilityVC animated:true];
    }
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      HotelListViewController *hotelListVC = [[HotelListViewController alloc]init];
      [self.navigationController pushViewController:hotelListVC animated:true];
    } else if (indexPath.row == 1) {
      GuestTableViewController *guestListVC = [[GuestTableViewController alloc]init];
      [self.navigationController pushViewController:guestListVC animated:true];
    }
  }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"Reservation";
  } else if (section == 1) {
    return @"Search";
  } else {
    return @"";
  }
}

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
}


@end
