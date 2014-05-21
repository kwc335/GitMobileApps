//
//  Level.h
//  CookieCrunch
//
//  Created by Koh Wee Chong on 20/5/14.
//  Copyright (c) 2014 KWC. All rights reserved.
//

#import "Cookie.h"
#import "Tile.h"
#import "Swap.h"
#import "Chain.h"

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface Level : NSObject

@property (assign, nonatomic) NSUInteger targetScore;
@property (assign, nonatomic) NSUInteger maximumMoves;

- (NSSet *)shuffle;
- (Cookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row;
- (instancetype)initWithFile:(NSString *)filename;
- (Tile *)tileAtColumn:(NSInteger)column row:(NSInteger)row;
- (void)performSwap:(Swap *)swap;
- (BOOL)isPossibleSwap:(Swap *)swap;
- (NSSet *)removeMatches;
- (NSArray *)fillHoles;
- (NSArray *)topUpCookies;
- (void)detectPossibleSwaps;
- (void)resetComboMultiplier;

@end
