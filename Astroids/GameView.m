//
//  MainView.m
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "GameView.h"
#import "Ship.h"
#import "LaserBlast.h"
#import "Asteroid.h"
#import "HitPointSubView.h"
#import "FlashMessageView.h"
#import <AVFoundation/AVFoundation.h>

@interface GameView()

@property (nonatomic) ShipType shipType;
@property (strong,nonatomic) Ship *ship;
@property (strong,nonatomic) HitPointSubView *hpView;

@property UILabel *pointsLabel;
@property (strong,nonatomic) NSTimer *collisionLoop;
@property (strong,nonatomic) AVAudioPlayer *laserPlayer;
@property (strong,nonatomic) UITapGestureRecognizer *tap;
@property (strong,nonatomic) CALayer *infiniteBackground;
@property (strong,nonatomic) NSMutableArray *allAsteroids;
@property (strong,nonatomic) NSMutableArray *allPlayerLasers;
@property (strong,nonatomic) NSMutableArray *allEnemyLasers;
@property (strong,nonatomic) NSMutableArray *allEnemyShips;
@property int points;



- (BOOL) isMovingLeft:(CGPoint)touchPoint;
- (void)setInfiniteSpaceScrollingWithBackgroundImage:(UIImage*)backgroundImage;
@end

@implementation GameView

- (void)setPlayerScore:(int)playerScore
{
    _playerScore = playerScore;
    self.pointsLabel.text = [NSString stringWithFormat:@"Score: %d",self.playerScore];
}

- (void)setPlayerHitPoints:(int)playerHitPoints
{
    _playerHitPoints = playerHitPoints;
    self.hpView.playerHitPoints = _playerHitPoints;
    [self.hpView updateView];
    [self updateView];
}

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
    //  Set pointsEarned
    self.points = 0;

    //  Initialize UITapGesture
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shootPlayerLaser:)];
    self.tap.numberOfTapsRequired = 2;
    
    //  Set handler for the tap gesture recognizer for the view
    [self addGestureRecognizer:self.tap];
    
    //  Initialize the background Layer
    self.infiniteBackground = [CALayer layer];
    [self setInfiniteSpaceScrollingWithBackgroundImage:[UIImage imageNamed:@"level1Background.png"]];
      
    //  Initialize laser player
//    NSString *laser = [[NSBundle mainBundle] pathForResource:@"laser" ofType:@"mp4"];
//    self.laserPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:laser] error:NULL];
//    self.laserPlayer.volume = 0.25;
//    [self.laserPlayer prepareToPlay];
    
    //  Initialize the ship and stats
    [self initPlayerShipAndStats];    
    
    //  Create allPlayerLasers Array
    self.allPlayerLasers = [NSMutableArray new];
    
    //  Create allEnemyLasers Array
    self.allEnemyLasers = [NSMutableArray new];
    
    //  Initialize all asteroids Array
    self.allAsteroids = [NSMutableArray new];
 
    //  Initialize all enemyShips Array
    self.allEnemyShips = [NSMutableArray new];
    
    //  Add asteroids
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
    [self addAsteroid];
     
    
    //  Add enemy ship
    [self addEnemyShipOfType:Tie];
    [self addEnemyShipOfType:Tie];
    [self addEnemyShipOfType:Tie];
    
    //  Add the  HitPoint subview
    self.hpView = [[HitPointSubView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 30, self.bounds.size.height - 100, 7.5, 100) maxHP:self.playerHitPoints andPlayerHP:self.playerHitPoints];
    [self addSubview:self.hpView];
    [self bringSubviewToFront:self.hpView];
    
    //  Add a UILabel for the Points
    self.pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, self.bounds.size.height - 15.0, 120.0, 15.0)];
    self.pointsLabel.textColor = [UIColor redColor];
    self.pointsLabel.backgroundColor = [UIColor clearColor];
    self.pointsLabel.text = @"Score: ";
    [self addSubview:self.pointsLabel];
    
    [self setNeedsDisplay];
}

- (void)initPlayerShipAndStats
{
    self.playerScore = 0;
    self.playerHitPoints = 10;
     
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

- (void)setInfiniteSpaceScrollingWithBackgroundImage:(UIImage*)backgroundImage
{
    UIImage *spaceImage = backgroundImage;
    UIColor *spacePattern = [UIColor colorWithPatternImage:spaceImage];
    self.infiniteBackground.backgroundColor = spacePattern.CGColor;
    
    // CALayer's coordinates put the origin at the lower left instead of the upper left, with y increasing up, i.e  flip the image over the x-axis
    self.infiniteBackground.transform = CATransform3DMakeScale(1, -1, 1);
            
    CGSize viewSize = self.bounds.size;
    self.infiniteBackground.frame = CGRectMake(0, 0, spaceImage.size.width, spaceImage.size.height + viewSize.height);
    [self.layer addSublayer:self.infiniteBackground];
    
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

    [self.infiniteBackground addAnimation:animation forKey:@"position"];
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

- (void)startCollisionDetectionLoop
{
    self.collisionLoop = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(checkForCollisions) userInfo:nil repeats:YES];
}

- (void)stopCollisionDetection
{
    [self.collisionLoop invalidate];
}

- (void)checkForCollisions
{
    //  Check if enemy ship shot player with laser
    if ([self.allEnemyLasers count] != 0) {
        for (LaserBlast *enemyLaser in self.allEnemyLasers) {
            //if (CGRectIntersectsRect([self.ship.presentationLayer frame], [enemyLaser.presentationLayer frame]) ) {
            if (CGRectIntersectsRect([self.ship collisionRectangle], [enemyLaser.presentationLayer frame]) ) {
                // Ship has been hit by enemy laser blast
                [self.delegate playerHit];
            }
        }
    }
    
    //  Check if player hit asteroid
    if ([self.allAsteroids count] != 0) {
        for (Asteroid *asteroid in self.allAsteroids) {
            //if (CGRectIntersectsRect([self.ship.presentationLayer frame], [asteroid.presentationLayer frame]) ) {
            if (CGRectIntersectsRect([self.ship collisionRectangle],[asteroid.presentationLayer frame]) ) {
                // Ship has collided with an asteroid
                
                // NSLog(@"Ship collided with asteroid");
                [self.delegate playerDied];
            }
        }
    }

    NSMutableArray *lasersToBeRemoved    = [NSMutableArray new];
    NSMutableArray *enemyShipsToBeRemoved = [NSMutableArray new];
    
    
    //  Check if player shot enemy ship with laser
    if ([self.allPlayerLasers count] != 0) {        
        for (LaserBlast *laser in self.allPlayerLasers) {
            for (EnemyShip *enemy in self.allEnemyShips) {
                if (CGRectIntersectsRect([laser.presentationLayer frame], [enemy.presentationLayer frame]) ) {

                    //  NSLog(@"Player destroyed enemy ship");
                    self.points += 10;
                    NSString *baseString = @"POINTS ";
                    NSString *pointsString = [NSString stringWithFormat:@"%d",self.points];
                    self.pointsLabel.text = [baseString stringByAppendingString:pointsString];
                    
                    
                    //  Remove from the SuperLayer
                    [enemy removeFromSuperlayer];

                    //  Update points label
                    self.playerScore += 5;
                    
                    [enemy destroyShip];

                    [laser removeFromSuperlayer];
                    
                    //  Add to the tobeRemoved arrays
                    [enemyShipsToBeRemoved addObject:enemy];
                    [lasersToBeRemoved addObject:laser];
                    
                    // unset animation delegate for asteroid and laser (AVOID REFERENCE RETAIN CYCLE)
                    [laser unsetAnimationDelegate];
                }
            }
        }
    }
    
    //  Remove the enemy ship and lasers that have collided
    if ([enemyShipsToBeRemoved count] != 0) {
        [self.allEnemyShips removeObjectsInArray:enemyShipsToBeRemoved];
        [self.allPlayerLasers removeObjectsInArray:lasersToBeRemoved];
        [self.delegate enemyDestroyed];
    }
     
    
    //  Check for laser / asteroid collision
    NSMutableArray *asteroidsToBeRemoved = [NSMutableArray new];
     
    for (LaserBlast *laser in self.allPlayerLasers) {
        for (Asteroid *asteroid in self.allAsteroids) {
            if (CGRectIntersectsRect([laser.presentationLayer frame], [asteroid.presentationLayer frame]) ) {

                [asteroid destroyAsteroid];
                                
                // Remove from the SuperLayer
                //[asteroid removeFromSuperlayer];
                [laser removeFromSuperlayer];
              
                // Add to the tobeRemoved arrays
                [asteroidsToBeRemoved addObject:asteroid];
                [lasersToBeRemoved addObject:laser];
                                
                // unset animation delegate for asteroid and laser (AVOID REFERENCE RETAIN CYCLE)
                //[asteroid unsetAnimationDelegate];
                [laser unsetAnimationDelegate];
            }
        }
    }
    
    //  Remove the asteroids and lasers that have collided
    if ([asteroidsToBeRemoved count] != 0) {
        [self.delegate asteroidDestroyed];
        [self.allAsteroids removeObjectsInArray:asteroidsToBeRemoved];
        [self.allPlayerLasers removeObjectsInArray:lasersToBeRemoved];
    }
}

- (void)shootPlayerLaser:(UIGestureRecognizer*) gesture
{
    //  Play laser sound
    //[self.laserPlayer play];

    //  Get the ship's presentation layer's position (the ship might be in the middle of an animation)
    //  In order to get this presentation layer's position we have to TELL the Compiler that what we get back from the method "presentationLayer" is a CALayer, thus we CAST it to a CALayer*
    CGPoint laserOrigin = [(CALayer*)[self.ship presentationLayer] position];
   
    //  Create new laser object and give it a reference to the NSMutableArray that will hold it (so when the laser deletes itself from its superlayer it can also remove itself from this container)
    LaserType laserType = player;
    LaserBlast *laserBlast = [[LaserBlast alloc] initWithPosition:laserOrigin targetPosition:CGPointMake(laserOrigin.x, -50) laserType:laserType AndLaserArrayContainer:self.allPlayerLasers];
    
    //  Add laser object to view's layer
    [self.layer addSublayer:laserBlast];

    //  Add laser to GameView's allLaserBlasts Array
    [self.allPlayerLasers addObject:laserBlast];
    
    //  Call the laser's animation method.  Also note that the laserBlast object will also remove itself from its superLayer by means of an animation delegate callback method in itself.
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

- (void)addEnemyShipOfType:(EnemyShipType)type
{
    //  Create a new enemy ship with a reference to the player's ship
    if (self.ship) {
        CGFloat x = arc4random() % (int)self.bounds.size.width;
        CGFloat y = -10.0;
 
        // NSLog(@"Adding new enemy at position: %f,%f",x,y);
        
        EnemyShip *tieFighter = [[EnemyShip alloc] initWithPosition:CGPointMake(x,y) shipType:type playerShip:self.ship andAllENemyLasersArray:self.allEnemyLasers];
        [self.layer addSublayer:tieFighter];
        [tieFighter animate];
        [self.allEnemyShips addObject:tieFighter];
    }
}

- (void)addChainOfEnemyShips
{
    //  Add code to create a new chain of enemy ships
}

- (void)nextLevel:(GameLevel)level
{
    [self.collisionLoop invalidate];

    switch (level) {
        case second: {
            //  Remove any remaining asteroids from level 1
            for (Asteroid *asteroid in self.allAsteroids) {
                [asteroid removeFromSuperlayer];
            }
            self.allAsteroids = nil;
            
            [self setInfiniteSpaceScrollingWithBackgroundImage:[UIImage imageNamed:@"level3Background.png"]];
            [self addEnemyShipOfType:Interceptor];
            [self addEnemyShipOfType:Interceptor];
            [self addEnemyShipOfType:Tie];
            [self addEnemyShipOfType:Tie];
            
            //  Flash the next level
            FlashMessageView *levelUp = [[FlashMessageView alloc] initWithFrame:CGRectMake(50.0, 50.0, 200.0, 80.0) andTitle:@"LEVEL 2"];
            [self addSubview:levelUp];
            [self bringSubviewToFront:levelUp];
            [levelUp scaleUp];
        }
            break;
        case third: {
                       
            [self setInfiniteSpaceScrollingWithBackgroundImage:[UIImage imageNamed:@"level2Background.png"]];
            [self addEnemyShipOfType:Bomber];
            [self addEnemyShipOfType:Bomber];
            [self addEnemyShipOfType:Bomber];
            [self addEnemyShipOfType:Bomber];
            [self addEnemyShipOfType:Tie];
            [self addEnemyShipOfType:Interceptor];
            [self addEnemyShipOfType:Interceptor];
            [self addEnemyShipOfType:Tie];
            
            //  Flash the next level
            FlashMessageView *levelUp = [[FlashMessageView alloc] initWithFrame:CGRectMake(50.0, 50.0, 200.0, 80.0) andTitle:@"LEVEL 3"];
            [self addSubview:levelUp];
            [self bringSubviewToFront:levelUp];
            [levelUp scaleUp];
        }
            break;
            
        default:
            break;
    }

    [self bringSubviewToFront:self.hpView];
    [self bringSubviewToFront:self.pointsLabel];
    
    [self startCollisionDetectionLoop];
    [self updateView];
}

- (void)updateView
{
    [self setNeedsDisplay];
}

- (void)stopGame
{
    //  Stop the collision detection loop
    [self.collisionLoop invalidate];
    
    //  Remove tap gesture recognizer
    self.tap = nil;
    
    //  Stop all animation
    for (EnemyShip *enemy in self.allEnemyShips) {
        [enemy removeAnimationForKey:@"movement"];
        //  [enemy unsetAnimationDelegate];
    }
    
//    for (Asteroid *asteroid in self.allAsteroids) {
//        [CATransaction begin];
//        [CATransaction setDisableActions:YES];
//        asteroid.position = [(CALayer*)asteroid.presentationLayer position];
//        [CATransaction commit];
//        
//        [asteroid removeAnimationForKey:@"moveAndRotate"];
//        [asteroid unsetAnimationDelegate];
//    }
}

@end