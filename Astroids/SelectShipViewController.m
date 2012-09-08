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

@end

@implementation SelectShipViewController

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
    // Each ship button has been given within Interface-Builder a tag attribute ranging from 0 to 3
    switch (sender.tag) {
        case 0:
            self.ship = falcon;
            break;
        case 1:
            self.ship = xwing;
            break;
        case 2:
            self.ship = twing;
            break;
        case 3:
            self.ship = ywing;
            break;
        default:
            NSLog(@"Invalid ship type selected");
            break;
    }
    //  NSLog(@"User selected ship %d",self.ship);
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
        //[self.navigationController pushViewController:gameController animated:NO];
        [self presentViewController:gameController animated:NO completion:nil];
    }
}

@end
