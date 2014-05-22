//
//  Venue.h
//  CoffeeKit
//
//  Created by Koh Wee Chong on 22/5/14.
//  Copyright (c) 2014 KWC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;
@class Stats;

@interface Venue : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) Stats *stats;

@end
