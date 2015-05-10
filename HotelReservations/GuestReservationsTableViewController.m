//
//  GuestReservationsTableViewController.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/7/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "GuestReservationsTableViewController.h"
#import "HotelReservationsStyleKit.h"
#import "Guest.h"
#import "Reservation.h"
#import "HotelHeaderView.h"
#import "AppDelegate.h"
#import "HotelService.h"
#import "MainDetailImageTableViewCell.h"
#import "Room.h"
#import "NoResultsTableViewCell.h"

const int kCurrentReservationSectionIndex = 0;
const int kPastReservationsSectionIndex = 1;

@interface GuestReservationsTableViewController ()

@property(strong,nonatomic)NSDateFormatter *dateFormatter;
@property(strong,nonatomic)NSArray *reservations;

@end

@implementation GuestReservationsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
  titleLabel.text = [NSString stringWithFormat:@"%@, %@", self.selectedGuest.lastName, self.selectedGuest.firstName];
  self.navigationItem.titleView = titleLabel;
  
  [self.tableView registerClass:[MainDetailImageTableViewCell class] forCellReuseIdentifier:@"GuestDetailCell"];
  [self.tableView registerClass:[NoResultsTableViewCell class] forCellReuseIdentifier:@"NoResultsCell"];
  
  [self getSections];
}


-(void)getSections {
  NSMutableArray *pastReservations = [[NSMutableArray alloc]init];
  NSMutableArray *futureReservations = [[NSMutableArray alloc]init];
  NSMutableArray *reservations = [[NSMutableArray alloc]initWithObjects:futureReservations,pastReservations, nil];
  
  NSArray *guestReservations = self.selectedGuest.reservations.allObjects;
  for (int i = 0; i < guestReservations.count;i++) {
    Reservation *reservation = guestReservations[i];
    NSComparisonResult result = [reservation.endDate compare:[NSDate date]];
    if (result == NSOrderedAscending || result == NSOrderedSame) {
      [pastReservations addObject:reservation];
    } else {
      [futureReservations addObject:reservation];
    }
  }
  [reservations setObject:futureReservations atIndexedSubscript:0];
  [reservations setObject:pastReservations atIndexedSubscript:1];
  self.reservations  = reservations;
}

//MARK:
//MARK: UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([self.reservations[section] count] == 0) {
    return 1;
  } else {
    return [self.reservations[section] count];
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *section = self.reservations[indexPath.section];
  if (section.count == 0) {
    NoResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoResultsCell" forIndexPath:indexPath];
    if (indexPath.section == kCurrentReservationSectionIndex) {
      cell.mainLabel.text = @"Guest has no current reservations";
    } else {
      cell.mainLabel.text = @"Guest has no past reservations";
    }
    return cell;
  } else {
    MainDetailImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestDetailCell" forIndexPath:indexPath];
    Reservation *reservation = section[indexPath.row];
    self.dateFormatter = [[NSDateFormatter alloc]init];
    self.dateFormatter.dateFormat = @"MMM dd";
    NSString *fromDateStr = [self.dateFormatter stringFromDate:reservation.startDate];
    NSString *toDateStr = [self.dateFormatter stringFromDate:reservation.endDate];
    cell.mainLabel.text = [NSString stringWithFormat:@"Confirmation #%@",reservation.confirmationID];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@ through %@", fromDateStr, toDateStr];
    cell.mainImageView.image = nil;
    Room *room = reservation.room;
    if (room.actualImage == nil) {
      UIImage *roomImage = [UIImage imageWithData:room.image];
      room.actualImage = roomImage;
    }
    cell.mainImageView.image = room.actualImage;
    return cell;
  }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.reservations.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 100;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"Current Reservations";
  } else {
    return @"Past Reservations";
  }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[HotelHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
  UILabel * headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 4, 100, 20)];
  [headerView addSubview:headerLabel];
  headerLabel.translatesAutoresizingMaskIntoConstraints = false;
  
  NSDictionary *views = @{@"headerLabel": headerLabel};
  NSArray *hHeaderLabelLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[headerLabel]" options:0 metrics:nil views:views];
  [headerView addConstraints:hHeaderLabelLayoutConstraint];
  NSArray *vHeaderLabelLayoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[headerLabel]" options:0 metrics:nil views:views];
  [headerView addConstraints:vHeaderLabelLayoutConstraint];
  
  headerLabel.text = [self tableView:self.tableView titleForHeaderInSection:section];
  headerLabel.textColor = [UIColor whiteColor];
  return headerView;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return UITableViewCellEditingStyleDelete;
  } else {
    return UITableViewCellEditingStyleNone;
  }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *sectionReservations = self.reservations[indexPath.section];
  Reservation *reservation = sectionReservations[indexPath.row];
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.hotelService deleteReservation:reservation];
  [self getSections];
  [self.tableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
  return @"Cancel";
}

@end
