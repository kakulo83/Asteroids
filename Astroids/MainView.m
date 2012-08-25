//
//  MainView.m
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "MainView.h"
#import <AVFoundation/AVFoundation.h>
#import "Ship.h"
#import "LaserBlast.h"
#import "Asteroid.h"

@interface MainView()
{
    Ship *ship;
    AVAudioPlayer *laserPlayer;
    NSMutableArray *allAsteroids;
}

@property (nonatomic, strong) UITapGestureRecognizer *tap;
- (BOOL) isMovingLeft:(CGPoint)touchPoint;
- (void) initInfiniteSpaceScrolling;

@end

@implementation MainView

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
    [self addGestureRecognizer:self.tap];
    
    // Initialize the background
    [self initInfiniteSpaceScrolling];
    
    // Initialize laser player
    NSString *music = [[NSBundle mainBundle] pathForResource:@"laser" ofType:@"mp4"];
    laserPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:music] error:NULL];
    
    // Initialize the ship
    CGPoint position = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height - 35);
    ship = [[Ship alloc] initWithPosition:position];
    [self.layer addSublayer:ship];
    [self setNeedsDisplay];
      
    // Initialize some asteroids
    Asteroid *asteroid0 = [[Asteroid alloc] initWithPosition:CGPointMake(150.0, 20.0) andDirection:CGPointMake(20, 15) ];
    [[self layer] addSublayer:asteroid0];
    [asteroid0 animate];
    
    Asteroid *asteroid1 = [[Asteroid alloc] initWithPosition:CGPointMake(235.0, 56.0) andDirection:CGPointMake(-45, 60)];
    [[self layer] addSublayer:asteroid1];
    [asteroid1 animate];
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

- (void) shootLaser:(UIGestureRecognizer*) gesture {
    // Play laser sound
    [laserPlayer play];

    // Get the ship's presentation layer's position (the ship might be in the middle of an animation)
    // In order to get this presentation layer's position we have to TELL the Compiler that what we get back from the method "presentationLayer" is a CALayer, thus we CAST it to a CALayer*
    CGPoint laserOrigin = [(CALayer*)[ship presentationLayer] position];
        
    // Create new laser object
    LaserBlast *laserBlast = [[LaserBlast alloc] initWithPosition:laserOrigin];
    
    // Add laser object to view's layer
    [self.layer addSublayer:laserBlast];
   
    // Call the laser's animation method.  Also note that the laserBlast object will also remove itself from its superLayer by means of an animation delegate callback method in itself.
    [laserBlast animate];
    
    //  Invoke method that checks if there are any asteroids along the lasers path

}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    
    // "Bank" the ship in the direction of the movement
    if ([self isMovingLeft:touchLocation]) {
        ship.transform = CATransform3DMakeRotation(-15.0, 0.0, 1.0, 0.0);
    }
    else {
        ship.transform = CATransform3DMakeRotation(15.0, 0.0, 1.0, 0.0);
    }

    // Move the ship to the position
    ship.position = touchLocation;

    // Check if the ship has touched any asteroids
    
}

@end
