//
//  MainViewController.m
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "GameViewController.h"
#import "WelcomeViewController.h"
#import "SelectShipViewController.h"
#import "ScoreViewController.h"
#import "GameView.h"
#import <AVFoundation/AVFoundation.h>
#import "GameOverView.h"

@interface GameViewController () <GameViewEventDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) AVAudioPlayer *musicPlayer;
@property (nonatomic) int points;
@property (nonatomic) int numberOfLives;
@property (nonatomic) GameLevel level;
@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initGameProperties];
    }
    return self;
}

- (void)loadView
{
    GameView *view = [[GameView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0) andShipType:self.shipType];
    view.delegate = self;
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    NSString *music = [[NSBundle mainBundle] pathForResource:@"astroid" ofType:@"mp4"];
//    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:music] error:NULL];
//    [self.musicPlayer play];
}

- (void)viewDidAppear:(BOOL)animated
{
    //  Cast the view to a GameView object first then star the continuous collision detection for both ship/asteroid and asteroid/laser
    [(GameView*) self.view startCollisionDetectorLoop];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/* *************************************  Game View delegate methods *********************************** */

- (void)initGameProperties
{
    self.points = 0;
    self.numberOfLives = 3;
    self.level = first;
}

- (void)playerDied
{
    //  prompt player if they want to try again or go to the score screen
    //  NSLog(@"You have died");
    
    [(GameView *)self.view stopGame];
    
    //  Flash a view to the user asking them if they would like to play again or view the score screen
    UIActionSheet *optionsActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Main Menu", @"Play Again", @"Score Screen", nil];
    [optionsActionSheet showInView:self.view];
    [optionsActionSheet setDelegate:self];
}

- (void)enemyDestroyed
{
    self.points += 10;
    
    if ((self.points >= 50) && (self.level == first) ) {
        //  NSLog(@"Entering second level");
        self.level = second;
        GameView *view = (GameView *) self.view;
        [view nextLevel:second];
    }
    // enough points for second level
    else if ((self.points >= 100) && (self.level == second)) {
        //  NSLog(@"Entering third level");
        self.level = third;
        GameView *view = (GameView *) self.view;
        [view nextLevel:third];
    }
    
    // if all enemies are destroyed but not enough points for the next level have been achieved, create a new batch of enemies
    else {
        GameView *gView = (GameView *)self.view;
        [gView addEnemyShipOfType:Interceptor];
    }
}

- (void)asteroidDestroyed
{
    // NSLog(@"You have destroyed an asteroid");
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            WelcomeViewController *welcomeController = [WelcomeViewController new];
            [self presentViewController:welcomeController animated:YES completion:nil];
        }
        case 1: {
            SelectShipViewController *selectShipController = [SelectShipViewController new];
            [self presentViewController:selectShipController animated:YES completion:nil];
        }
        case 2: {
            ScoreViewController *scoreViewController = [ScoreViewController new];
            [self presentViewController:scoreViewController animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

@end
