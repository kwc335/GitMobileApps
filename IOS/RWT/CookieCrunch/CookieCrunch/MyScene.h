//
//  MyScene.h
//  CookieCrunch
//

//  Copyright (c) 2014 KWC. All rights reserved.
//

@import SpriteKit;

@class Level;
@class Swap;

@interface MyScene : SKScene

@property (strong, nonatomic) Level *level;
@property (copy, nonatomic) void (^swipeHandler)(Swap *swap);

- (void)addSpritesForCookies:(NSSet *)cookies;
- (void)addTiles;
- (void)animateSwap:(Swap *)swap completion:(dispatch_block_t)completion;
- (void)animateInvalidSwap:(Swap *)swap completion:(dispatch_block_t)completion;
- (void)animateMatchedCookies:(NSSet *)chains completion:(dispatch_block_t)completion;
- (void)animateFallingCookies:(NSArray *)columns completion:(dispatch_block_t)completion;
- (void)animateNewCookies:(NSArray *)columns completion:(dispatch_block_t)completion;
- (void)animateGameOver;
- (void)animateBeginGame;
- (void)removeAllCookieSprites;

@end
