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
#import "SearchButtonTableViewCell.h"
#import "AvailabilityTableViewController.h"
#import "HotelHeaderView.h"

@interface MainMenuTableViewController ()

@property(strong,nonatomic)DateTableViewCell *fromCell;
@property(strong,nonatomic)DateTableViewCell *toCell;
@property(strong,nonatomic)UITableViewCell *fromDateCell;
@property(strong,nonatomic)UITableViewCell *toDateCell;
@property(strong,nonatomic)UITableViewCell *searchHotelsCell;
@property(strong,nonatomic)SearchButtonTableViewCell *searchButtonCell;
@property(strong, nonatomic)UIDatePicker *fromDatePicker;
@property(strong, nonatomic)UIDatePicker *toDatePicker;
@property(nonatomic)BOOL showFromDate;
@property(nonatomic)BOOL showToDate;
@property(strong,nonatomic)NSDateFormatter *dateFormatter;

@end

@implementation MainMenuTableViewController

-(void)loadView {
  self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  self.fromCell = [[DateTableViewCell alloc]init];
  self.toCell = [[DateTableViewCell alloc]init];
  self.fromDateCell = [[UITableViewCell alloc]init];
  self.fromDatePicker = [[UIDatePicker alloc]init];
  [self.fromDateCell addSubview:self.fromDatePicker];
  self.fromDateCell.clipsToBounds = true;
  self.toDateCell = [[UITableViewCell alloc]init];
  self.toDatePicker = [[UIDatePicker alloc]init];
  [self.toDateCell addSubview:self.toDatePicker];
  self.toDateCell.clipsToBounds = true;
  self.searchHotelsCell = [[UITableViewCell alloc]init];
  self.searchHotelsCell.textLabel.text = @"Search Hotels";
  [self.searchHotelsCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  self.searchButtonCell = [[SearchButtonTableViewCell alloc]init];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.fromDatePicker.datePickerMode = UIDatePickerModeDate;
  self.toDatePicker.datePickerMode = UIDatePickerModeDate;
  self.dateFormatter = [[NSDateFormatter alloc]init];
  self.dateFormatter.dateFormat = @"EEEE, MMMM dd";
  [self.tableView registerClass:[DateTableViewCell class]forCellReuseIdentifier:@"FromToCell"];
  [self.tableView registerClass:[SearchButtonTableViewCell class]forCellReuseIdentifier:@"SearchButtonCell"];
  [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"SearchCell"];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.showFromDate = false;
  self.showToDate = false;
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
    return 5;
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
        case 1:
          return self.fromDateCell;
        case 2:
          if (self.toCell == nil) {
            self.toCell = [self.toCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FromToCell"];
          }
          self.toCell.fromToLabel.text = @"To:";
          return self.toCell;
        case 3:
          return self.toDateCell;
        case 4:
          if (self.searchButtonCell == nil) {
            self.searchButtonCell = [self.searchButtonCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchButtonCell"];
          }
          return self.searchButtonCell;
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
      } else
      self.showToDate = !self.showToDate;
      self.toDatePicker.alpha = 0;
      [UIView animateWithDuration:0.4 animations:^{
        self.toDatePicker.alpha = 1;
        [self.tableView reloadData];
      }];
    } else if (indexPath.row == 4) {
      AvailabilityTableViewController *availabilityVC = [[AvailabilityTableViewController alloc]init];
      availabilityVC.fromDate = self.fromDatePicker.date;
      availabilityVC.toDate = self.toDatePicker.date;
      [self.navigationController pushViewController:availabilityVC animated:true];
    }
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      HotelListViewController *hotelListVC = [[HotelListViewController alloc]init];
      [self.navigationController pushViewController:hotelListVC animated:true];
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


@end
