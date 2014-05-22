//
//  VenueCell.h
//  CoffeeKit
//
//  Created by Koh Wee Chong on 22/5/14.
//  Copyright (c) 2014 KWC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *checkinsLabel;

@end
