//
//  MainViewController.m
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "GameViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GameView.h"

@interface GameViewController () <GameViewEventDelegate>
@property (strong, nonatomic) AVAudioPlayer *musicPlayer;
@property (nonatomic) int pointsEarned;
@property (nonatomic) int numberOfLives;
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

/* **********************************  Game related methods *********************************** */

- (void)initGameProperties
{
    self.pointsEarned = 0;
    self.numberOfLives = 3;
}

- (void)playerDied
{
    // prompt player if they want to try again or go to the score screen
    NSLog(@"You have died");
}

- (void)enemyDestroyed
{
    self.pointsEarned += 20;
    
    // if the player has earned enough points destroying enemies move to the next level
    if (self.pointsEarned >= 100) {
        GameView *view = (GameView *) self.view;
        [view nextLevel];
    }
    // if all enemies are destroyed but not enough points for the next level have been achieved, create a new batch of enemies
    else {
        GameView *gView = (GameView *)self.view;
        [gView addEnemyShip];
        [gView addEnemyShip];
        [gView addEnemyShip];
    }
}

- (void)asteroidDestroyed
{
    // NSLog(@"You have destroyed an asteroid");
    
}

@end
