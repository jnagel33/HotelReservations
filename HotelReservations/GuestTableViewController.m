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
#import "GlobalConstants.h"
#import "HotelHeaderView.h"
#import "GlobalConstants.h"

@interface GuestTableViewController ()

@property(strong,nonatomic)NSArray *guests;

@end

@implementation GuestTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kTitleLabelWidth, kTitleLabelHeight)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.font = [UIFont fontWithName:kFontName size:kTitleFontSize];
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
  NSArray *guests = [appDelegate.hotelService fetchAllGuests];
  self.guests = [self getSections:guests];
  [self.tableView reloadData];
}

-(NSArray *)getSections: (NSArray *)guests {
  NSMutableArray *sections = [[NSMutableArray alloc]init];
  Guest *previousGuest;
  for (Guest *guest in guests) {
    NSString *firstLetter = [[guest.lastName substringToIndex:1]uppercaseString];
    NSString *prevFirstLetter = [[previousGuest.lastName substringToIndex:1]uppercaseString];
    if (previousGuest) {
      if ([prevFirstLetter isEqualToString:firstLetter]) {
        NSMutableArray *sectionArray = sections[sections.count - 1];
        [sectionArray addObject:guest];
      } else {
        NSMutableArray *sectionArray = [[NSMutableArray alloc]initWithObjects:guest, nil];
        [sections addObject:sectionArray];
      }
    } else {
      NSMutableArray *firstSection = [[NSMutableArray alloc]initWithObjects:guest, nil];
      [sections addObject:firstSection];
    }
    previousGuest = guest;
  }
  return sections;
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *guestSection = self.guests[section];
  return guestSection.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestCell" forIndexPath:indexPath];
  NSArray *guestSection = self.guests[indexPath.section];
  Guest *guest = guestSection[indexPath.row];
  NSString *nameStr = [NSString stringWithFormat:@"%@, %@", guest.lastName, guest.firstName];
  cell.textLabel.text = nameStr;
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *guestSection = self.guests[indexPath.section];
  Guest *guest = guestSection[indexPath.row];
  GuestReservationsTableViewController *guestReservationsVC = [[GuestReservationsTableViewController alloc]init];
  guestReservationsVC.selectedGuest = guest;
  [self.navigationController pushViewController:guestReservationsVC animated:true];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.guests.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *headerView = [[HotelHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHeaderViewHeight)];
  UILabel * headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(kHeaderViewLabelLeadingSpace, kHeaderViewLabelTopSpace, kHeaderViewLabelWidth, kHeaderViewLabelHeight)];
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
  NSArray *guestSection = self.guests[section];
  Guest *guest = guestSection[0];
  NSString *lastNameFirstCharacter = [[guest.lastName substringToIndex:1]uppercaseString];
  return lastNameFirstCharacter;
}



@end
