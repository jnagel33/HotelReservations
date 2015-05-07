//
//  AvailabilityTableViewController.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/5/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "AvailabilityTableViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Reservation.h"
#import "Room.h"
#import "HotelService.h"
#import "HotelHeaderView.h"
#import "Hotel.h"
#import "ReserveRoomTableViewController.h"
#import "HotelReservationsStyleKit.h"

@interface AvailabilityTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@property(strong,nonatomic)NSDateFormatter *dateFormatter;

@end

@implementation AvailabilityTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.dateFormatter = [[NSDateFormatter alloc]init];
  self.dateFormatter.dateFormat = @"MMM d";
  NSString *fromDateStr = [self.dateFormatter stringFromDate:self.fromDate];
  NSString *toDateStr = [self.dateFormatter stringFromDate:self.toDate];
  
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.text = [NSString stringWithFormat:@"%@th to %@th", fromDateStr, toDateStr];
  self.navigationItem.titleView = titleLabel;
  
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AvailableRoomsCell"];
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  self.fetchedResultsController = [appDelegate.hotelService produceFetchResultsControllerForAvailableRoomsFromDate:self.fromDate toDate:self.toDate withBedCount:self.bedCount];
  self.fetchedResultsController.delegate = self;
  NSError *fetchError;
  [self.fetchedResultsController performFetch:&fetchError];
  if (fetchError != nil) {
    NSLog(@"%@", fetchError.localizedDescription);
  }
}

//MARK:
//MARK: NSFetchedResultsControllerDelegate

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
  
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
    case NSFetchedResultsChangeMove:
      [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    default:
      break;
  }
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
}

//MARK:
//MARK: UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  return self.availableRooms.count;
  NSArray *sections = [self.fetchedResultsController sections];
  id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AvailableRoomsCell" forIndexPath:indexPath];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.fetchedResultsController.sections count];
}


-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Room *room = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%hd",room.number];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
  Room *room = [[sectionInfo objects]objectAtIndex:0];
  Hotel *hotel = room.hotel;
  return hotel.name;
}


//MARK: UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ReserveRoomTableViewController *reserveRoomVC = [[ReserveRoomTableViewController alloc]init];
  reserveRoomVC.selectedRoom = [self.fetchedResultsController objectAtIndexPath:indexPath];
  reserveRoomVC.fromDate = self.fromDate;
  reserveRoomVC.toDate = self.toDate;
  [self.navigationController pushViewController:reserveRoomVC animated:true];
}

@end
