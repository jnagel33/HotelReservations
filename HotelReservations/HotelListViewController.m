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
#import "MainDetailImageTableViewCell.h"
#import "HotelHeaderView.h"
#import "HotelService.h"
#import "HotelReservationsStyleKit.h"
#import "ImageResizer.h"

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
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18];
  titleLabel.text = @"Hotels";
  self.navigationItem.titleView = titleLabel;
  
  self.tableView.delegate = self;
  [self.tableView registerClass:[MainDetailImageTableViewCell class]forCellReuseIdentifier:@"HotelCell"];
  
  [self fetchHotels];
  self.tableView.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchHotels) name:@"DataChanged" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)fetchHotels {
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  NSArray *allHotels = [appDelegate.hotelService fetchAllHotels];
  self.hotels = [self getSections:allHotels];
}

-(NSArray *)getSections:(NSArray *)hotels {
  NSMutableArray *sections = [[NSMutableArray alloc]init];
  NSMutableArray *checkedHotels = [[NSMutableArray alloc]init];
  for (int i = 0; i < hotels.count; i++) {
    Hotel *hotel = hotels[i];
    if (checkedHotels.count == 0) {
      NSMutableArray *firstHotelSection = [[NSMutableArray alloc]initWithObjects:hotel, nil];
      [sections addObject:firstHotelSection];
    } else {
      Hotel *lastCheckedHotel = checkedHotels.lastObject;
      if (lastCheckedHotel.stars == hotel.stars) {
        NSMutableArray *lastCheckedSection = sections[sections.count - 1];
        [lastCheckedSection addObject:hotel];
      } else {
        NSMutableArray *newSection = [[NSMutableArray alloc]init];
        [newSection addObject:hotel];
        [sections addObject:newSection];
      }
    }
    [checkedHotels addObject:hotel];
  }
  return sections;
}

//MARK:
//MARK: UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *sectionHotels = self.hotels[section];
  return sectionHotels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MainDetailImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelCell" forIndexPath:indexPath];
  NSArray *starSection = self.hotels[indexPath.section];
  Hotel *hotel = starSection[indexPath.row];
  cell.mainImageView.image = nil;
  cell.mainLabel.text = [NSString stringWithFormat:@"%@",hotel.name];
  cell.detailLabel.text = hotel.location;
  if (hotel.actualImage == nil) {
    UIImage *hotelImage = [UIImage imageWithData:hotel.image];
    hotel.actualImage = hotelImage;
  }
  cell.mainImageView.image = hotel.actualImage;
  return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.hotels.count;
}

//MARK:
//MARK: UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:true];
  NSArray *hotelsSection = self.hotels[indexPath.section];
  Hotel *hotel = hotelsSection[indexPath.row];
  RoomsListViewController *roomsListVC = [[RoomsListViewController alloc]init];
  roomsListVC.hotel = hotel;
  [self.navigationController pushViewController:roomsListVC animated:true];
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
  NSArray *sectionHotels = self.hotels[section];
  Hotel *firstHotel = sectionHotels[0];
  NSMutableArray *stars = [[NSMutableArray alloc]init];
  for (int i = 0; i < firstHotel.stars; i++) {
    [stars addObject:@"☆"];
  }
  return [stars componentsJoinedByString:@""];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 100;
}

//MARK: Constraints

-(void)setConstraintsForRootView:(UIView *)view withView:(NSDictionary *)dictionary {
  NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:dictionary];
  [view addConstraints:tableViewHorizontalConstraints];
  NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:dictionary];
  [view addConstraints:tableViewVerticalConstraints];
}

@end
