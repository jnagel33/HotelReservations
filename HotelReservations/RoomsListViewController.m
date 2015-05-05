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
  self.navigationItem.title = self.hotel.name;
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RoomCell"];
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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCell" forIndexPath:indexPath];
  Room *room = self.rooms[indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%hd",room.number];
  return cell;
}

@end
