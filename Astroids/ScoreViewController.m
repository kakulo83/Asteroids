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
//    NSArray *allPlayers;
//    NSMutableArray *allPlayerPhotos;
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
        //  query parse for data
        PFQuery *query = [PFQuery queryWithClassName:@"PlayerData"];
        [query orderByDescending:@"playerScore"];
        self.allPlayers = [query findObjects];
        
        self.allPlayerPhotos = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView setSeparatorColor:[UIColor blueColor]];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"playerCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"playerCell"];
    }
    
    NSString *playerName = [[self.allPlayers objectAtIndex:indexPath.row] objectForKey:@"playerName"];
    NSString *playerScore= [NSString stringWithFormat:@"%@",[[self.allPlayers objectAtIndex:indexPath.row] objectForKey:@"playerScore"]];

    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 15.0, 150.0, 15.0)];
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.text = playerName;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:18.0];
    
    
    UILabel *scoreLabel= [[UILabel alloc] initWithFrame:CGRectMake(220.0, 15.0, 75.0, 15.0)];
    scoreLabel.textAlignment = UITextAlignmentRight;
    scoreLabel.text = playerScore;
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.backgroundColor = [UIColor blackColor];
    scoreLabel.font = [UIFont systemFontOfSize:18.0];
    
   [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:scoreLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PFFile *file =[[self.allPlayers objectAtIndex:indexPath.row]objectForKey:@"imageFile"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data && !error) {
            UIImage *playerImage = [UIImage imageWithData:data];
                                   
            //  Add UIImage to allUIImages array
            [self.allPlayerPhotos addObject:playerImage];
            
            cell.imageView.image = playerImage;
            [cell setNeedsLayout];
        }
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allPlayers count];
}

- (IBAction)gameMenuPressed
{
    WelcomeViewController *welcomeController = [WelcomeViewController new];
    [self presentViewController:welcomeController animated:YES completion:nil];
}

@end
