//
//  SelectShipViewController.m
//  Astroids
//
//  Created by Robert Carter on 8/25/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "SelectShipViewController.h"
#import "GameViewController.h"

@interface SelectShipViewController ()
{

}

//  ShipType is defined in the GameViewController header file which has been imported here
@property ShipType ship;

//  Outlets needed for highlighting effect
@property (weak, nonatomic) IBOutlet UIButton *selectFalconButton;
@property (weak, nonatomic) IBOutlet UIButton *selectXWingButton;
@property (weak, nonatomic) IBOutlet UIButton *selectTWingButton;
@property (weak, nonatomic) IBOutlet UIButton *selectYWingButton;
@end

@implementation SelectShipViewController
@synthesize selectFalconButton = _selectFalconButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSelectFalconButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)selectShipPressed:(UIButton *)sender
{
    [self.selectFalconButton setBackgroundImage:[UIImage imageNamed:@"selectFalcon.png"] forState:UIControlStateNormal];
    [self.selectXWingButton  setBackgroundImage:[UIImage imageNamed:@"selectXWing.png"]  forState:UIControlStateNormal];
    [self.selectTWingButton  setBackgroundImage:[UIImage imageNamed:@"selectTWing.png"]  forState:UIControlStateNormal];
    [self.selectYWingButton  setBackgroundImage:[UIImage imageNamed:@"selectYWing.png"]  forState:UIControlStateNormal];
    
    // Each ship button has been given within Interface-Builder a tag attribute ranging from 0 to 3
    switch (sender.tag) {
        case 1: {
            self.ship = falcon;
            [sender setBackgroundImage:[UIImage imageNamed:@"selectFalconHighlighted.png"] forState:UIControlStateNormal];
        }
            break;
        case 2: {
            self.ship = xwing;
            [sender setBackgroundImage:[UIImage imageNamed:@"selectXWingHighlighted.png"] forState:UIControlStateNormal];
        }
            break;
        case 3: {
            self.ship = twing;
            [sender setBackgroundImage:[UIImage imageNamed:@"selectTWingHighlighted.png"] forState:UIControlStateNormal];
        }
            break;
        case 4: {
            self.ship = ywing;
            [sender setBackgroundImage:[UIImage imageNamed:@"selectYWingHighlighted.png"] forState:UIControlStateNormal];
        }
            break;
        default: {
            NSLog(@"Invalid ship type selected");
        }
        break;
    }
    
    //  NSLog(@"Selected ship %u", self.ship);
}

- (IBAction)startPressed
{
    // Check if the user has selected a ship, if not flash an alert
    if (!self.ship) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Select your coffin"
                                                        message:@"You must select a ship"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        GameViewController *gameController = [GameViewController new];
        gameController.shipType = self.ship;
        [self presentViewController:gameController animated:NO completion:nil];
    }
}

@end
