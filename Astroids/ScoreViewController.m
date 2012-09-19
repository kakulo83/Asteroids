//
//  ScoreViewController.m
//  Astroids
//
//  Created by Robert Carter on 8/25/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "ScoreViewController.h"
#import "WelcomeViewController.h"
#import <Parse/Parse.h>

@interface ScoreViewController () 
{
    
}
@property (strong, nonatomic) NSArray *allPlayers;
@property (strong, nonatomic) NSMutableArray *allPlayerPhotos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ScoreViewController
@synthesize tableView = _tableView;

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
    self.tableView.backgroundColor = [UIColor blackColor];

    //  query parse for data
    PFQuery *query = [PFQuery queryWithClassName:@"PlayerData"];
    self.allPlayers = [query findObjects];
    self.allPlayerPhotos = [NSMutableArray new];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create cell of data and return it
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault    reuseIdentifier:nil];
    
    cell.textLabel.text = [[self.allPlayerPhotos objectAtIndex:indexPath.row] objectForKey:@"imageName"];
    
    
    PFFile *file =[[self.allPlayerPhotos objectAtIndex:indexPath.row]objectForKey:@"imageFile"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *previewImage = [UIImage imageWithData:data];
            
            // Add UIImage to allUIImages array
            [self.allPlayerPhotos addObject:previewImage];
            
            cell.imageView.image = previewImage;
            [cell setNeedsLayout];
        }
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allPlayers count];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)gameMenuPressed
{
    WelcomeViewController *welcomeController = [WelcomeViewController new];
    [self presentViewController:welcomeController animated:YES completion:nil];
}

@end
