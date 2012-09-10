//
//  MainView.m
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "GameView.h"
#import <AVFoundation/AVFoundation.h>
#import "Ship.h"
#import "EnemyShip.h"
#import "LaserBlast.h"
#import "Asteroid.h"

@interface GameView()
{
//    AVAudioPlayer *laserPlayer;
//    NSMutableArray *allAsteroids;
//    NSMutableArray *allLasers;
    NSTimer *collisionLoop;
}
@property (nonatomic) ShipType shipType;
@property (strong,nonatomic) Ship *ship;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (strong,nonatomic) NSMutableArray *allAsteroids;
@property (strong,nonatomic) NSMutableArray *allPlayerLasers;
@property (strong,nonatomic) NSMutableArray *allEnemyLasers;
@property (strong,nonatomic) NSMutableArray *allEnemyShips;

- (BOOL) isMovingLeft:(CGPoint)touchPoint;
- (void)initInfiniteSpaceScrollingWithBackgroundImage:(UIImage*)backgroundImage;
@end

@implementation GameView

- (id)initWithFrame:(CGRect)frame andShipType:(ShipType)shipType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shipType = shipType;
        [self initObjects];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initObjects];
}

- (void)initObjects
{
    // Initialize UITapGesture
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shootLaser:)];
    self.tap.numberOfTapsRequired = 2;
    
    // Set handler for the tap gesture recognizer for the view
    [self addGestureRecognizer:self.tap];
    
    // Initialize the background
    [self initInfiniteSpaceScrollingWithBackgroundImage:[UIImage imageNamed:@"space.png"]];
    
    // Initialize laser player
//    NSString *music = [[NSBundle mainBundle] pathForResource:@"laser" ofType:@"mp4"];
//    laserPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:music] error:NULL];
//    [laserPlayer prepareToPlay];
    
    // Initialize the ship
    [self initPlayerShip];
            
    // Create allPlayerLasers Array
    self.allPlayerLasers = [NSMutableArray new];
    
    // Create allEnemyLasers Array
    self.allEnemyLasers = [NSMutableArray new];
    
    // Initialize some asteroids Array
    self.allAsteroids = [NSMutableArray new];
 
    // Add asteroid
    [self addAsteroid];
    
    // Add enemy ship
    [self addEnemyShip];
            
    [self setNeedsDisplay];
}

- (void)initPlayerShip
{
    CGPoint position = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height - 35);
    
    switch (self.shipType) {
        case 1: {
            self.ship = [[Ship alloc] initWithPosition:position andImageFile:@"falcon.png"];
        }
            break;
        case 2: {
            self.ship = [[Ship alloc] initWithPosition:position andImageFile:@"xwing.png"];
        }
            break;
        case 3: {
            self.ship = [[Ship alloc] initWithPosition:position andImageFile:@"twing.png"];
        }
            break;
        case 4: {
            self.ship = [[Ship alloc] initWithPosition:position andImageFile:@"ywing.png"];
        }
            break;
        default:
            break;
    }
    [self.layer addSublayer:self.ship];
}

- (void)initInfiniteSpaceScrollingWithBackgroundImage:(UIImage*)backgroundImage
{
    UIImage *spaceImage = backgroundImage;
    UIColor *spacePattern = [UIColor colorWithPatternImage:spaceImage];
    CALayer *space = [CALayer layer];
    space.backgroundColor = spacePattern.CGColor;
    
    // CALayer's coordinates put the origin at the lower left instead of the upper left, with y increasing up, i.e  flip the image over the x-axis
    space.transform = CATransform3DMakeScale(1, -1, 1);
            
    CGSize viewSize = self.bounds.size;
    space.frame = CGRectMake(0, 0, spaceImage.size.width, spaceImage.size.height + viewSize.height);
    [self.layer addSublayer:space];
    
    // Set the start and end conditions for the animation property that will change
    CGPoint startPoint = CGPointMake(viewSize.width/2.0,0.0); 
    CGPoint endPoint = CGPointMake(viewSize.width/2.0 , spaceImage.size.height/3.0);

    // Set the property that this animation will change over the course of the animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:startPoint];
    animation.toValue = [NSValue valueWithCGPoint:endPoint];
    animation.repeatCount = INT_MAX;
    animation.duration = 10.0;

    [space addAnimation:animation forKey:@"position"];
}

- (BOOL)isMovingLeft:(CGPoint)touchPoint
{
    if (touchPoint.x < self.ship.position.x) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)startCollisionDetectorLoop
{
    collisionLoop = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(checkForCollisions) userInfo:nil repeats:YES];
}

- (void)checkForCollisions
{
    // Check for enemy ship laser / player ship collision
 
    
    
    // Check for ship/asteroid collision
    if ([self.allAsteroids count] != 0) {
        for (Asteroid *asteroid in self.allAsteroids) {
            if (CGRectIntersectsRect([self.ship.presentationLayer frame], [asteroid.presentationLayer frame])) {
                // Ship has collided with an asteroid
                
                // NSLog(@"Ship collided with asteroid");
                [self.delegate playerDied];
            }
        }
    }
 
    // Check for laser/asteroid collision (store asteroids and lasers in a temp array for deletion after the fast loop)
    NSMutableArray *asteroidsToBeRemoved = [NSMutableArray new];
    NSMutableArray *lasersToBeRemoved    = [NSMutableArray new];
     
    for (LaserBlast *laser in self.allPlayerLasers) {
        for (Asteroid *asteroid in self.allAsteroids) {
                        
            if (CGRectIntersectsRect([laser.presentationLayer frame], [asteroid.presentationLayer frame]) ) {
                [self.delegate asteroidDestroyed];
                
                // Remove from the SuperLayer
                [asteroid removeFromSuperlayer];
                [laser removeFromSuperlayer];
              
                // Add to the tobeRemoved arrays
                [asteroidsToBeRemoved addObject:asteroid];
                [lasersToBeRemoved addObject:laser];
                                
                // unset animation delegate for asteroid and laser (AVOID REFERENCE RETAIN CYCLE)
                [asteroid unsetAnimationDelegate];
                [laser unsetAnimationDelegate];
            }
        }
    }
    
    // Remove the asteroids and lasers that have collided
    if ([asteroidsToBeRemoved count] != 0) {
        [self.allAsteroids removeObjectsInArray:asteroidsToBeRemoved];
        [self.allPlayerLasers removeObjectsInArray:lasersToBeRemoved];
    }
}

- (void)shootLaser:(UIGestureRecognizer*) gesture
{
    // Play laser sound
    //[laserPlayer play];

    // Get the ship's presentation layer's position (the ship might be in the middle of an animation)
    // In order to get this presentation layer's position we have to TELL the Compiler that what we get back from the method "presentationLayer" is a CALayer, thus we CAST it to a CALayer*
    CGPoint laserOrigin = [(CALayer*)[self.ship presentationLayer] position];
   
    // Create new laser object and give it a reference to the NSMutableArray that will hold it (so when the laser deletes itself from its superlayer it can also remove itself from this container)
    LaserBlast *laserBlast = [[LaserBlast alloc] initWithPosition:laserOrigin AndLaserArrayContainer:self.allPlayerLasers];
    
    // Add laser object to view's layer
    [self.layer addSublayer:laserBlast];

    // Add laser to GameView's allLaserBlasts Array
    [self.allPlayerLasers addObject:laserBlast];
    
    // Call the laser's animation method.  Also note that the laserBlast object will also remove itself from its superLayer by means of an animation delegate callback method in itself.
    [laserBlast animate];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    
    // "Bank" the ship in the direction of the movement
    if ([self isMovingLeft:touchLocation]) {
        CGFloat angle = -40 * M_PI / 180.0;
        self.ship.transform = CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
    }
    else {
        CGFloat angle = 40 * M_PI / 180.0;
        self.ship.transform = CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
    }

    // Move the ship to the position
    self.ship.position = touchLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.ship.transform = CATransform3DIdentity;
}

- (void)addAsteroid
{
    //  Add code to create new asteroid obstacles
    Asteroid *asteroid = [[Asteroid alloc] initWithPosition:CGPointMake(0.0, 0.0) andEndPosition:CGPointMake(120, 750) ];
    [[self layer] addSublayer:asteroid];
    [self.allAsteroids addObject:asteroid];
    [asteroid animate];
}

- (void)addEnemyShip
{
    //  Create a new enemy ship with a reference to the player's ship
    if (self.ship) {
        EnemyShip *tieFighter = [[EnemyShip alloc] initWithPosition:CGPointMake(15.0, 50.0) imageFile:@"tieFighter.png" playerShip:self.ship andAllENemyLasersArray:self.allEnemyLasers];
        [self.layer addSublayer:tieFighter];
        [tieFighter animate];
        [self.allEnemyShips addObject:tieFighter];
    }
}

- (void)addChainOfEnemyShips
{
    //  Add code to create a new chain of enemy ships
}

- (void)nextLevel
{
    //  Change the background imagery
    [self initInfiniteSpaceScrollingWithBackgroundImage:[UIImage imageNamed:@"level2Background.png"]];
    
    //  Add code to change the level background
    
    //  Add more ships thereby increasing the difficulty

    
    //  Update the view to show the level change
    [self updateView];
}

- (void)updateView
{
    [self setNeedsDisplay];
}

@end
