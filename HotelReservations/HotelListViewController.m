//
//  HotelListViewController.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/4/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "HotelListViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Hotel.h"
#import "RoomsListViewController.h"
#import "HotelTableViewCell.h"

@interface HotelListViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)NSArray *hotels;

@end

@implementation HotelListViewController

-(void)loadView {
  UIView *rootView = [[UIView alloc]init];
  self.tableView = [[UITableView alloc]init];
  [rootView addSubview:self.tableView];
  NSDictionary *views = @{@"tableView": self.tableView};
  [self setConstraintsForRootView:rootView withView:views];
  self.tableView.translatesAutoresizingMaskIntoConstraints = false;
  
  self.view = rootView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"Hotels";
  self.tableView.delegate = self;
  [self.tableView registerClass:[HotelTableViewCell class]forCellReuseIdentifier:@"HotelCell"];
  
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"stars" ascending:false];
  [fetchRequest setSortDescriptors:@[sortDescriptor]];
  
  
  NSError *fetchError;
  NSArray *myHotels = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
  if (fetchError != nil) {
    NSLog(@"%@", fetchError.localizedDescription);
  } else {
    self.hotels = myHotels;
  }
  self.tableView.dataSource = self;
}

//MARK:
//MARK: UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.hotels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
  [cell layoutSubviews];
  Hotel *hotel = self.hotels[indexPath.row];
  NSString *stars = [NSString stringWithFormat:@"%hd",hotel.stars];
  cell.nameLabel.text = [NSString stringWithFormat:@"%@ - %@",hotel.name, stars];
  cell.locationLabel.text = hotel.location;
  [cell layoutIfNeeded];
  return cell;
}

//MARK:
//MARK: UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:true];
  Hotel *hotel = self.hotels[indexPath.row];
  RoomsListViewController *roomsListVC = [[RoomsListViewController alloc]init];
  roomsListVC.hotel = hotel;
  [self.navigationController pushViewController:roomsListVC animated:true];
}

//MARK: Constraints

-(void)setConstraintsForRootView:(UIView *)view withView:(NSDictionary *)dictionary {
  NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:dictionary];
  [view addConstraints:tableViewHorizontalConstraints];
  NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:dictionary];
  [view addConstraints:tableViewVerticalConstraints];
}


@end
