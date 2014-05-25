//
//  ViewController.m
//  Quiz
//
//  Created by Koh Wee Chong on 25/5/14.
//  Copyright (c) 2014 KWC. All rights reserved.
//

#import "ViewController.h"

#import <iAd/iAd.h>

@interface ViewController () <ADBannerViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) UIButton *skipQuestionButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) NSArray *questions;
@property (assign, nonatomic) NSInteger currentQuestionIndex;
@property (assign, nonatomic) NSInteger maxAllowedQuestions;
@property (assign, nonatomic) NSInteger score;

@end

@implementation ViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setupQuiz];
}

#pragma mark - Private

- (void)setupQuiz
{
#ifdef FREE
    self.navigationItem.title = @"Free Version";
    self.maxAllowedQuestions = 2;
    [self setupAds];
#else
    self.navigationItem.title = @"Full Version";
    self.maxAllowedQuestions = 4;
    
    self.skipQuestionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.skipQuestionButton setFrame:CGRectMake(20, 80, 100, 44)];
    [self.skipQuestionButton setTitle:@"Skip Question" forState:UIControlStateNormal];
    [self.skipQuestionButton addTarget:self action:@selector(skipButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.skipQuestionButton];
#endif
  
  NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"QuizQuestions" ofType:@"plist"];
  self.questions = [NSArray arrayWithContentsOfFile:plistPath];
  self.currentQuestionIndex = 0;
  [self showNextQuestion];
}

- (void)showNextQuestion
{
  // 1 - handle last question
  if (self.currentQuestionIndex + 1 > self.maxAllowedQuestions) {
    NSString *message = [NSString stringWithFormat:@"Your score is %ld of %ld.", (long)self.score, (long)self.maxAllowedQuestions];
    [[[UIAlertView alloc] initWithTitle:@"GameOver" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    return;
  }
  
  // 2 - update view for next question
  NSDictionary *questionDetail = self.questions[self.currentQuestionIndex];
  self.questionLabel.text = questionDetail[@"question"];
  
  for (int buttonCount = 1; buttonCount <= 4; buttonCount++) {
    UIButton *answerButton = (UIButton *)[self.view viewWithTag:buttonCount];
    NSString *stringAnswer = questionDetail[[NSString stringWithFormat:@"answer%d", buttonCount]];
    [answerButton setTitle:stringAnswer forState:UIControlStateNormal];
  }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - IBActions

- (IBAction)answerButtonPressed:(UIButton *)sender
{
  int correctAnswer = [(NSNumber *)self.questions[self.currentQuestionIndex][@"correctAnswer"] intValue];
  if (sender.tag == correctAnswer) {
    self.score++;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
  }
  self.currentQuestionIndex++;
  [self showNextQuestion];
}

#pragma mark - Selectors

- (void)skipButtonPressed
{
  self.score++;
  self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)self.score];
  
  self.currentQuestionIndex++;
  [self showNextQuestion];
  
  self.skipQuestionButton.hidden = YES;
}

#pragma mark - Private

- (void)setupAds
{
  ADBannerView *bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, 320, 50)];
  bannerView.delegate = self;
  [self.view addSubview:bannerView];
}

#pragma mark - AdViewDelegate

- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
  NSLog(@"Ad Will Load - %s", __PRETTY_FUNCTION__);
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  NSLog(@"Ad Loaded - %s", __PRETTY_FUNCTION__);
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
  NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
  NSLog(@"Error Loading");
}

@end
