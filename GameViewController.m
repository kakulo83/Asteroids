//
//  MainViewController.m
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "GameViewController.h"
#import "WelcomeViewController.h"
#import "SelectShipViewController.h"
#import "EnterNameViewController.h"
#import "ScoreViewController.h"
#import "GameView.h"
#import "GameOverView.h"
#import "FlashMessageView.h"

@interface GameViewController () <GameViewEventDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) AVAudioPlayer *musicPlayer;
@property (nonatomic) int playerScore;
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

//  Starts the collision detection
- (void)viewDidAppear:(BOOL)animated
{
    //  Cast the view to a GameView object first then star the continuous collision detection for both ship/asteroid and asteroid/laser
    [(GameView*) self.view startCollisionDetectionLoop];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)initGameProperties
{
    self.playerScore = 0;
    self.numberOfLives = 3;
    self.level = first;
}

/* *************************************  Game View delegate methods *********************************** */

- (void)playerDied
{
    //  Stop the movement of the enemy ships
    GameView *gameView = (GameView *)self.view;
    [gameView stopGame];

    //  Star the player ship destruction sequence

    
    
    //  After the destruction sequence present a view with button options to Play Again or View Score

    GameOverView *gameOverView = [[GameOverView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 200.0) / 2.0, 160.0, 200.0, 200.0)];
    [gameOverView setBackgroundColor:[UIColor blackColor]];
    gameOverView.layer.borderColor = [[UIColor blueColor] CGColor];
    gameOverView.layer.borderWidth = 1.0f;
    [[gameOverView layer] setZPosition:3000.0];

    //  Create DarthVader disapproves image
    UIImageView *vaderImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 200.0) / 2.0 + 50, 170.0, 100.0, 100.0)];
    [vaderImage setImage:[UIImage imageNamed:@"gameOver.png"]];
    [gameOverView addSubview:vaderImage];
    
    //  Create Play Again Button
    UIButton *playAgainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [playAgainButton setFrame:CGRectMake((self.view.bounds.size.width - 200.0) / 2.0 + 25, 275.0, 150.0, 30.0)];
    [playAgainButton setBackgroundImage:[UIImage imageNamed:@"blackButtonBackground.png"] forState:UIControlStateNormal];
    [playAgainButton setTitle:@"Play Again" forState:UIControlStateNormal];
    [playAgainButton addTarget:self action:@selector(playAgain) forControlEvents:UIControlEventTouchDown];
    [gameOverView addSubview:playAgainButton];

    //  Create Score Button
    UIButton *scoreScreenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scoreScreenButton setFrame:CGRectMake((self.view.bounds.size.width - 200.0) / 2.0 + 25, 315.0, 150.0, 30.0)];
    [scoreScreenButton setBackgroundImage:[UIImage imageNamed:@"blackButtonBackground.png"] forState:UIControlStateNormal];
    [scoreScreenButton setTitle:@"View Scores" forState:UIControlStateNormal];
    [scoreScreenButton addTarget:self action:@selector(viewScoreScreen) forControlEvents:UIControlEventTouchDown];
    [gameOverView addSubview:scoreScreenButton];
    
    //  Add GameOver View to GameView
    [gameView addSubview:gameOverView];
    [gameView bringSubviewToFront:gameOverView];
}

- (void)playerHit
{
    GameView *view = (GameView *) self.view;
            
    view.playerHitPoints -= 1;
    
    if (view.playerHitPoints == 0) {
        [self playerDied];
    }
}

- (void)enemyDestroyed
{
    self.playerScore += 5;
    
    if ((self.playerScore >= 25) && (self.level == first) ) {
        //  NSLog(@"Entering second level");
        self.level = second;
        GameView *view = (GameView *) self.view;
        [view nextLevel:second];
    }
    // enough points for second level
    else if ((self.playerScore >= 60) && (self.level == second)) {
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
    [(GameView *)self.view addAsteroid];
}

- (void)playAgain
{
    SelectShipViewController *selectShipController = [SelectShipViewController new];
    [self presentViewController:selectShipController animated:YES completion:nil];
}

- (void)viewScoreScreen
{
    EnterNameViewController *enterNameController = [EnterNameViewController new];
    enterNameController.playerScore = self.playerScore;
    [self presentViewController:enterNameController animated:YES completion:nil];
}

@end
