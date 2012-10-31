//
//  WelcomeViewController.m
//  Astroids
//
//  Created by Robert Carter on 8/25/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "WelcomeViewController.h"
#import "SelectShipViewController.h"
#import "ScoreViewController.h"

@interface WelcomeViewController ()
@property (strong, nonatomic) AVAudioPlayer *musicPlayer;
@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        NSString *music = [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp3"];
//        self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:music] error:NULL];
//        [self.musicPlayer play];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Hide the navigation controller's top bar
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // Hide the navigation controller's top bar
//    [self.navigationController setNavigationBarHidden:YES];
//    [self.musicPlayer stop];
//    self.musicPlayer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)playButtonPressed {
    // Push the SelectShipViewController
    SelectShipViewController *selectShipController = [SelectShipViewController new];

    // Replace navigationController with:  [self
    [self presentViewController:selectShipController animated:YES completion:nil];
    
    [self.navigationController pushViewController:selectShipController animated:YES];
}

- (IBAction)scoresButtonPressed {
    // Push the ScoreViewController
    ScoreViewController *scoreController = [ScoreViewController new];
    [self presentViewController:scoreController animated:YES completion:nil];
}

@end
