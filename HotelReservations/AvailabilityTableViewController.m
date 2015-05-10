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
#import "SearchTableViewHeaderView.h"
#import "MainDetailImageTableViewCell.h"
#import "ImageResizer.h"
#import "NoResultsTableViewCell.h"

@interface AvailabilityTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(strong,nonatomic)NSDateFormatter *dateFormatter;
@property(strong,nonatomic)UIView *tableViewHeaderView;
@property(strong,nonatomic)UILabel *dateRangeLabel;
@property(strong,nonatomic)UILabel *locationLabel;
@property(strong,nonatomic)UILabel *bedsLabel;


@end

@implementation AvailabilityTableViewController

-(void)loadView {
  [super loadView];
  self.tableViewHeaderView = [[SearchTableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
  self.dateRangeLabel = [[UILabel alloc]init];
  self.dateRangeLabel.textColor = [UIColor whiteColor];
  self.dateRangeLabel.translatesAutoresizingMaskIntoConstraints = false;
  [self.tableViewHeaderView addSubview:self.dateRangeLabel];
  self.locationLabel = [[UILabel alloc]init];
  self.locationLabel.textColor = [UIColor whiteColor];
  self.locationLabel.translatesAutoresizingMaskIntoConstraints = false;
  [self.tableViewHeaderView addSubview:self.locationLabel];
  self.bedsLabel = [[UILabel alloc]init];
  self.bedsLabel.textColor = [UIColor whiteColor];
  self.bedsLabel.translatesAutoresizingMaskIntoConstraints = false;
  [self.tableViewHeaderView addSubview:self.bedsLabel];
  NSDictionary *views = @{@"dateRangeLabel": self.dateRangeLabel, @"locationLabel": self.locationLabel, @"bedsLabel": self.bedsLabel};
  [self setConstraintsWithViews:views];
  
  [self.tableView setTableHeaderView:self.tableViewHeaderView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
  titleLabel.text = @"Search Results";
  self.navigationItem.titleView = titleLabel;
  
  self.dateFormatter = [[NSDateFormatter alloc]init];
  self.dateFormatter.dateFormat = @"M/dd";
  NSString *fromDateStr = [self.dateFormatter stringFromDate:self.fromDate];
  NSString *toDateStr = [self.dateFormatter stringFromDate:self.toDate];
  self.dateRangeLabel.text = [NSString stringWithFormat:@"%@-%@", fromDateStr, toDateStr];
  if (self.location != nil) {
    self.locationLabel.text = self.location;
  } else {
    self.locationLabel.text = @"All";
  }
  self.bedsLabel.text = [NSString stringWithFormat:@"%hd+ beds",self.bedCount];
  
  [self.tableView registerClass:[MainDetailImageTableViewCell class]forCellReuseIdentifier:@"AvailableRoomsCell"];
  [self.tableView registerClass:[NoResultsTableViewCell class] forCellReuseIdentifier:@"NoResultsCell"];
  [self produceAvailableRoomsResultsController];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(produceAvailableRoomsResultsController) name:@"DataChanged" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)produceAvailableRoomsResultsController {
  self.fetchedResultsController = nil;
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  NSFetchedResultsController *newFetchController = [appDelegate.hotelService produceFetchResultsControllerForAvailableRoomsFromDate:self.fromDate toDate:self.toDate withBedCount:self.bedCount andLocation:self.location];
  NSError *fetchError;
  self.fetchedResultsController = newFetchController;
  [self.fetchedResultsController performFetch:&fetchError];
  if (fetchError != nil) {
    NSLog(@"%@", fetchError.localizedDescription);
  }
  self.fetchedResultsController.delegate = self;
  [self.tableView reloadData];
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
      [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
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
  if ([self.fetchedResultsController.sections count] == 0) {
    return 1;
  } else {
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
  }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.fetchedResultsController.sections count] == 0) {
    NoResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoResultsCell" forIndexPath:indexPath];
      cell.mainLabel.text = @"No results found";
    return cell;
  } else {
    MainDetailImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AvailableRoomsCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
  }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if ([self.fetchedResultsController.sections count] == 0) {
    return 1;
  }
  return [self.fetchedResultsController.sections count];
}


-(void)configureCell:(MainDetailImageTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  Room *room = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.mainLabel.text = [NSString stringWithFormat:@"Room #%hd",room.number];
  cell.detailLabel.text = [NSString stringWithFormat:@"$%hd / night",room.rate];
  cell.mainImageView.image = nil;
  if (room.actualImage == nil) {
    UIImage *roomImage = [UIImage imageWithData:room.image];
    room.actualImage = roomImage;
  }
  cell.mainImageView.image = room.actualImage;
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
  if ([self.fetchedResultsController.sections count] == 0) {
    return @"";
  } else {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]objectAtIndex:section];
    Room *room = [[sectionInfo objects]objectAtIndex:0];
    Hotel *hotel = room.hotel;
    return hotel.name;
  }
}


//MARK: UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ReserveRoomTableViewController *reserveRoomVC = [[ReserveRoomTableViewController alloc]init];
  reserveRoomVC.selectedRoom = [self.fetchedResultsController objectAtIndexPath:indexPath];
  reserveRoomVC.fromDate = self.fromDate;
  reserveRoomVC.toDate = self.toDate;
  [self.navigationController pushViewController:reserveRoomVC animated:true];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 100;
}

//MARK: Constraints

-(void)setConstraintsWithViews:(NSDictionary *)dictionary {
  NSArray *hTableViewHeaderSubviews = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[dateRangeLabel][bedsLabel]-10-|" options:0 metrics:nil views:dictionary];
  [self.tableViewHeaderView addConstraints:hTableViewHeaderSubviews];

  NSLayoutConstraint *dateRangeLabelCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.dateRangeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.tableViewHeaderView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.tableViewHeaderView addConstraint:dateRangeLabelCenterYLayoutConstraint];
  
  NSLayoutConstraint *locationLabelCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.tableViewHeaderView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.tableViewHeaderView addConstraint:locationLabelCenterYLayoutConstraint];
  
  NSLayoutConstraint *locationLabelCenterXLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.tableViewHeaderView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  [self.tableViewHeaderView addConstraint:locationLabelCenterXLayoutConstraint];
  
  NSLayoutConstraint *bedsLabelCenterYLayoutConstraint = [NSLayoutConstraint constraintWithItem:self.bedsLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.tableViewHeaderView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self.tableViewHeaderView addConstraint:bedsLabelCenterYLayoutConstraint];
}

@end
