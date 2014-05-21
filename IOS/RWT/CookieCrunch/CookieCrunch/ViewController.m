//
//  ViewController.m
//  CookieCrunch
//
//  Created by Koh Wee Chong on 20/5/14.
//  Copyright (c) 2014 KWC. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

#import "Level.h"

@import AVFoundation;

@interface ViewController ()

// Add private properties here
@property (strong, nonatomic) Level *level; // model
@property (strong, nonatomic) MyScene *scene; // view
@property (assign, nonatomic) NSUInteger movesLeft;
@property (assign, nonatomic) NSUInteger score;

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *movesLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gameOverPanel;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusic;

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  skView.multipleTouchEnabled = NO;
  
  // Create and configure the scene.
  self.scene = [MyScene sceneWithSize:skView.bounds.size];
  self.scene.scaleMode = SKSceneScaleModeAspectFill;
  
  // Load the level.
//  self.level = [[Level alloc] init];
  self.level = [[Level alloc] initWithFile:@"Level_1"];
  self.scene.level = self.level;  // tie model & view together
  
  [self.scene addTiles];
  
  id block = ^(Swap *swap) {
    self.view.userInteractionEnabled = NO;
    
    if ([self.level isPossibleSwap:swap]) {
      [self.level performSwap:swap];
//      [self.scene animateSwap:swap completion:^{
//        self.view.userInteractionEnabled = YES;
//      }];
      
      [self.scene animateSwap:swap completion:^{
        [self handleMatches];
      }];
      
    } else {
      [self.scene animateInvalidSwap:swap completion:^{
        self.view.userInteractionEnabled = YES;
      }];
    }
  };
  
  self.scene.swipeHandler = block;
  
  self.gameOverPanel.hidden = YES;
  
  // Present the scene.
  [skView presentScene:self.scene];
  
  NSURL *url = [[NSBundle mainBundle] URLForResource:@"Mining by Moonlight" withExtension:@"mp3"];
  self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
  self.backgroundMusic.numberOfLoops = -1;
  [self.backgroundMusic play];
  
  // Start game
  [self beginGame];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Private

- (void)showGameOver {
  [self.scene animateGameOver];
  
  self.gameOverPanel.hidden = NO;
  self.scene.userInteractionEnabled = NO;
  
  self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGameOver)];
  [self.view addGestureRecognizer:self.tapGestureRecognizer];
  
  self.shuffleButton.hidden = YES;
}

- (void)hideGameOver {
  [self.view removeGestureRecognizer:self.tapGestureRecognizer];
  self.tapGestureRecognizer = nil;
  
  self.gameOverPanel.hidden = YES;
  self.scene.userInteractionEnabled = YES;
  
  [self beginGame];
  
  self.shuffleButton.hidden = NO;
}

- (void)decrementMoves{
  self.movesLeft--;
  [self updateLabels];
  
  if (self.score >= self.level.targetScore) {
    self.gameOverPanel.image = [UIImage imageNamed:@"LevelComplete"];
    [self showGameOver];
  } else if (self.movesLeft == 0) {
    self.gameOverPanel.image = [UIImage imageNamed:@"GameOver"];
    [self showGameOver];
  }
}

- (void)updateLabels {
  self.targetLabel.text = [NSString stringWithFormat:@"%lu", (long)self.level.targetScore];
  self.movesLabel.text = [NSString stringWithFormat:@"%lu", (long)self.movesLeft];
  self.scoreLabel.text = [NSString stringWithFormat:@"%lu", (long)self.score];
}

- (void)handleMatches {
  NSSet *chains = [self.level removeMatches];
  
  if ([chains count] == 0) {
    [self beginNextTurn];
    return;
  }

  [self.scene animateMatchedCookies:chains completion:^{
    
    for (Chain *chain in chains) {
      self.score += chain.score;
    }
    [self updateLabels];
    
    NSArray *columns = [self.level fillHoles];
    [self.scene animateFallingCookies:columns completion:^{
      NSArray *columns = [self.level topUpCookies];
      [self.scene animateNewCookies:columns completion:^{
//        self.view.userInteractionEnabled = YES;
        [self handleMatches];
      }];
    }];
  }];
}

- (void)beginNextTurn {
  [self.level resetComboMultiplier];
  
  [self.level detectPossibleSwaps];
  self.view.userInteractionEnabled = YES;
  
  [self decrementMoves];
}

- (void)beginGame
{
  self.movesLeft = self.level.maximumMoves;
  self.score = 0;
  [self updateLabels];
  
  [self.level resetComboMultiplier];
  [self.scene animateBeginGame];
  [self shuffle];
}

- (void)shuffle
{
  [self.scene removeAllCookieSprites];
  
  NSSet *newCookies = [self.level shuffle];  // from Model
  [self.scene addSpritesForCookies:newCookies];  // to View
}

#pragma mark - IBAction

- (IBAction)shuffleButtonPressed:(id)sender {
  [self shuffle];
  [self decrementMoves];
}

@end
