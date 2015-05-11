//
//  RoomsListViewController.m
//  HotelReservations
//
//  Created by Josh Nagel on 5/4/15.
//  Copyright (c) 2015 jnagel. All rights reserved.
//

#import "RoomsListViewController.h"
#import "Hotel.h"
#import "Room.h"
#import "RoomTableViewCell.h"
#import "HotelReservationsStyleKit.h"
#import "GlobalConstants.h"

@interface RoomsListViewController () <UITableViewDataSource>

@property(strong,nonatomic)UITableView *tableView;
@property(strong, nonatomic)NSArray *rooms;

@end

@implementation RoomsListViewController

-(void)loadView {
  self.rooms = self.hotel.rooms.allObjects;
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
  UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kTitleLabelWidth, kTitleLabelHeight)];
  titleLabel.textColor = [HotelReservationsStyleKit blueDark];
  titleLabel.font = [UIFont fontWithName:kFontName size:kTitleFontSize];
  titleLabel.text = @"Main Menu";
  [self.tableView registerClass:[RoomTableViewCell class] forCellReuseIdentifier:@"RoomCell"];
  self.tableView.dataSource = self;
}

-(void)setConstraintsForRootView:(UIView *)view withView:(NSDictionary *)dictionary {
  NSArray *tableViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:dictionary];
  [view addConstraints:tableViewHorizontalConstraints];
  NSArray *tableViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:dictionary];
  [view addConstraints:tableViewVerticalConstraints];
}

//MARK:
//MARK: UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.rooms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  RoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCell" forIndexPath:indexPath];
  cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoomCell"];
  Room *room = self.rooms[indexPath.row];
  cell.rateLabel.text = [NSString stringWithFormat:@"$%hd",room.rate];
  cell.bedsLabel.text = [NSString stringWithFormat:@"%hd beds", room.beds];
  return cell;
}

@end
