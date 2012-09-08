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
    Ship *ship;
//    AVAudioPlayer *laserPlayer;
//    NSMutableArray *allAsteroids;
//    NSMutableArray *allLasers;
    NSTimer *collisionLoop;
}

@property (nonatomic, strong) UITapGestureRecognizer *tap;

- (BOOL) isMovingLeft:(CGPoint)touchPoint;
- (void) initInfiniteSpaceScrolling;

@end

@implementation GameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMainView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initMainView];
}

- (void)initMainView
{
    // Initialize UITapGesture
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shootLaser:)];
    self.tap.numberOfTapsRequired = 2;
    
    // Set handler for the tap gesture recognizer for the view
    [self addGestureRecognizer:self.tap];
    
    // Initialize the background
    [self initInfiniteSpaceScrolling];
    
    // Initialize laser player
//    NSString *music = [[NSBundle mainBundle] pathForResource:@"laser" ofType:@"mp4"];
//    laserPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:music] error:NULL];
//    [laserPlayer prepareToPlay];
    
    // Initialize the ship
    CGPoint position = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height - 35);
    ship = [[Ship alloc] initWithPosition:position andImageFile:@"falcon.png"];
    [self.layer addSublayer:ship];
        
    // Initialize allLasers Array
    self.allLaserBlasts = [NSMutableArray new];
    
    // Initialize some asteroids Array
    self.allAsteroids = [NSMutableArray new];
        
    Asteroid *asteroid0 = [[Asteroid alloc] initWithPosition:CGPointMake(0.0, 0.0) andEndPosition:CGPointMake(120, 750) ];
    [[self layer] addSublayer:asteroid0];
    [self.allAsteroids addObject:asteroid0];
    [asteroid0 animate];
        
    Asteroid *asteroid1 = [[Asteroid alloc] initWithPosition:CGPointMake(235.0, 6.0) andEndPosition:CGPointMake(-45, 600)];
    [[self layer] addSublayer:asteroid1];
    [asteroid1 animate];
    [self.allAsteroids addObject:asteroid1];
    
    Asteroid *asteroid2 = [[Asteroid alloc] initWithPosition:CGPointMake(235.0, 56.0) andEndPosition:CGPointMake(45, 600)];
    [[self layer] addSublayer:asteroid2];
    [asteroid2 animate];
    [self.allAsteroids addObject:asteroid2];
    
    
    // Initialize some tie fighters
    EnemyShip *tieFighter1 = [[EnemyShip alloc] initWithPosition:CGPointMake(15.0, 50.0) imageFile:@"tieFighter.png"];
    tieFighter1.allLaserBlasts = self.allLaserBlasts;
    [self.layer addSublayer:tieFighter1];
    [tieFighter1 animate];
    [self.allEnemyShips addObject:tieFighter1];

    [self setNeedsDisplay];
}

- (void) initInfiniteSpaceScrolling
{
    UIImage *spaceImage = [UIImage imageNamed:@"space.png"];
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
    if (touchPoint.x < ship.position.x) {
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
            if (CGRectIntersectsRect([ship.presentationLayer frame], [asteroid.presentationLayer frame])) {
                // Ship has collided with an asteroid
                
                NSLog(@"Ship collided with asteroid");
            }
        }
    }
 
    // Check for laser/asteroid collision (store asteroids and lasers in a temp array for deletion after the fast loop)
    NSMutableArray *asteroidsToBeRemoved = [NSMutableArray new];
    NSMutableArray *lasersToBeRemoved    = [NSMutableArray new];
     
    for (LaserBlast *laser in self.allLaserBlasts) {
        for (Asteroid *asteroid in self.allAsteroids) {
                        
            if (CGRectIntersectsRect([laser.presentationLayer frame], [asteroid.presentationLayer frame]) ) {
               
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
        [self.allLaserBlasts removeObjectsInArray:lasersToBeRemoved];
    }
}

- (void)shootLaser:(UIGestureRecognizer*) gesture
{
    // Play laser sound
    //[laserPlayer play];

    // Get the ship's presentation layer's position (the ship might be in the middle of an animation)
    // In order to get this presentation layer's position we have to TELL the Compiler that what we get back from the method "presentationLayer" is a CALayer, thus we CAST it to a CALayer*
    CGPoint laserOrigin = [(CALayer*)[ship presentationLayer] position];
   
    // Create new laser object and give it a reference to the NSMutableArray that will hold it (so when the laser deletes itself from its superlayer it can also remove itself from this container)
    LaserBlast *laserBlast = [[LaserBlast alloc] initWithPosition:laserOrigin AndLaserArrayContainer:self.allLaserBlasts];
    
    // Add laser object to view's layer
    [self.layer addSublayer:laserBlast];

    // Add laser to GameView's allLaserBlasts Array
    [self.allLaserBlasts addObject:laserBlast];
    
    // Call the laser's animation method.  Also note that the laserBlast object will also remove itself from its superLayer by means of an animation delegate callback method in itself.
    [laserBlast animate];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    
    // "Bank" the ship in the direction of the movement
    if ([self isMovingLeft:touchLocation]) {
        CGFloat angle = -40 * M_PI / 180.0;
        ship.transform = CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
    }
    else {
        CGFloat angle = 40 * M_PI / 180.0;
        ship.transform = CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
    }

    // Move the ship to the position
    ship.position = touchLocation;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    ship.transform = CATransform3DIdentity;
}


@end
