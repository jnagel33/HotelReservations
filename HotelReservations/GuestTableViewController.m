//
//  GuestTableViewController.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/6/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "GuestTableViewController.h"
#import "AppDelegate.h"
#import "HotelService.h"
#import "Guest.h"
#import "HotelReservationsStyleKit.h"
#import "GuestReservationsTableViewController.h"

@interface GuestTableViewController ()

@property(strong,nonatomic)NSArray *guests;

@end

@implementation GuestTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
  titleLabel.text = @"Guests";
  self.navigationItem.titleView = titleLabel;
  
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GuestCell"];
  
  [self fetchGuests];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchGuests) name:@"DataChanged" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)fetchGuests {
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  self.guests = [appDelegate.hotelService fetchAllGuests];
  [self.tableView reloadData];
}

//MARK:
//MARK: UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.guests.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestCell" forIndexPath:indexPath];
  Guest *guest = self.guests[indexPath.row];
  NSString *nameStr = [NSString stringWithFormat:@"%@, %@", guest.lastName, guest.firstName];
  cell.textLabel.text = nameStr;
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Guest *guest = self.guests[indexPath.row];
  GuestReservationsTableViewController *guestReservationsVC = [[GuestReservationsTableViewController alloc]init];
  guestReservationsVC.selectedGuest = guest;
  [self.navigationController pushViewController:guestReservationsVC animated:true];
}



@end
