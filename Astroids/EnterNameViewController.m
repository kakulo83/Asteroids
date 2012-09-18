//
//  EnterNameViewController.m
//  Astroids
//
//  Created by Robert Carter on 9/18/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "EnterNameViewController.h"

@interface EnterNameViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (strong, nonatomic) UIImage *playerImage;
@end

@implementation EnterNameViewController
@synthesize selectImageButton;

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
    [self setSelectImageButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)addImage
{
    //    ScoreViewController *scoreViewController = [ScoreViewController new];
    //    [self presentViewController:scoreViewController animated:YES completion:nil];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"Done entering name");
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
