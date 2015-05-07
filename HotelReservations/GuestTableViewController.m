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

@interface GuestTableViewController ()

@property(strong,nonatomic)NSArray *guests;

@end

@implementation GuestTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:22];
  titleLabel.text = @"Guests";
  self.navigationItem.titleView = titleLabel;
  
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GuestCell"];
  
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  self.guests = [appDelegate.hotelService fetchAllGuests];
  
}

//MARK:
//MARK: UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.guests.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestCell" forIndexPath:indexPath];
  Guest *guest = self.guests[indexPath.row];
  cell.textLabel.text = guest.firstName;
  return cell;
}

@end
