//
//  Chain.h
//  CookieCrunch
//
//  Created by Koh Wee Chong on 20/5/14.
//  Copyright (c) 2014 KWC. All rights reserved.
//

@class Cookie;

typedef NS_ENUM(NSUInteger, ChainType) {
  ChainTypeHorizontal,
  ChainTypeVertical,
};

@interface Chain : NSObject

@property (strong, nonatomic, readonly) NSArray *cookies;
@property (assign, nonatomic) ChainType chainType;
@property (assign, nonatomic) NSUInteger score;

- (void)addCookie:(Cookie *)cookie;

@end
