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

@interface GameViewController ()
{
    GameView *gameView;
}
@property (strong, nonatomic) AVAudioPlayer *musicPlayer;
@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //gameView = [GameView new];
        //[self setView:gameView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    //NSLog(@"User selected the ship" )
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
