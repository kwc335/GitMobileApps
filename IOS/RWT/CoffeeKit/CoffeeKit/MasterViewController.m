//
//  MasterViewController.m
//  CoffeeKit
//
//  Created by Koh Wee Chong on 22/5/14.
//  Copyright (c) 2014 KWC. All rights reserved.
//

#import "MasterViewController.h"

#import <RestKit/RestKit.h>
#import "Venue.h"
#import "Location.h"
#import "VenueCell.h"
#import "Stats.h"

#define kCLIENTID @"BUE44SE4B4AYQ4B0ME53BTVA1JWYCXP3TXQLCX3GHCJSZ2VH"
#define kCLIENTSECRET @"PVG5ZGUGTJBGNMGEYG2MDRZ0X1X3W1DW522NLE4DGZBE3OD2"

@interface MasterViewController ()

@property (nonatomic, strong) NSArray *venues;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configureRestKit];
  [self loadVenues];
}

#pragma mark - Private

- (void)configureRestKit
{
  // initialize AFNetworking HTTPClient
  NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
  AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
  
  // initialize RestKit
  RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
  
  // setup object mappings
  RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
  [venueMapping addAttributeMappingsFromArray:@[@"name"]];
  
  // register mappings with the provider using a response descriptor
  RKResponseDescriptor *responseDescriptor =
  [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
                                               method:RKRequestMethodGET
                                          pathPattern:@"/v2/venues/search"
                                              keyPath:@"response.venues"
                                          statusCodes:[NSIndexSet indexSetWithIndex:200]];
  
  [objectManager addResponseDescriptor:responseDescriptor];
  
  // define location object mapping
  RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
  [locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"crossStreet", @"postalCode", @"state", @"distance", @"lat", @"lng"]];
  
  // define relationship mapping
  [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];
  
  RKObjectMapping *statsMapping = [RKObjectMapping mappingForClass:[Stats class]];
  [statsMapping addAttributeMappingsFromDictionary:@{@"checkinsCount": @"checkins", @"tipsCount": @"tips", @"usersCount": @"users"}];
  
  [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"stats" toKeyPath:@"stats" withMapping:statsMapping]];
}

- (void)loadVenues
{
  NSString *latLon = @"37.33,-122.03"; // approximate latLon of The Mothership (a.k.a Apple headquarters)
  NSString *clientID = kCLIENTID;
  NSString *clientSecret = kCLIENTSECRET;
  
  NSDictionary *queryParams = @{@"ll" : latLon,
                                @"client_id" : clientID,
                                @"client_secret" : clientSecret,
                                @"categoryId" : @"4bf58dd8d48988d1e0931735",
                                @"v" : @"20140118"};
  
  [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
                                         parameters:queryParams
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                              _venues = mappingResult.array;
                                              [self.tableView reloadData];
                                            }
                                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                              NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                            }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell" forIndexPath:indexPath];
  
  Venue *venue = _venues[indexPath.row];
  cell.nameLabel.text = venue.name;
  cell.distanceLabel.text = [NSString stringWithFormat:@"%.0fm", venue.location.distance.floatValue];
  cell.checkinsLabel.text = [NSString stringWithFormat:@"%d checkins", venue.stats.checkins.intValue];
  
  return cell;
}

@end
