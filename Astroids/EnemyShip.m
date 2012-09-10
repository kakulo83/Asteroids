//
//  EnemyShip.m
//  Astroids
//
//  Created by Robert Carter on 8/27/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "EnemyShip.h"
#import "Ship.h"

@interface EnemyShip() {
    
}
@property Ship *playerShip;
@property NSMutableArray *allEnemyLasers;
@property CAAnimationGroup *animationGroup;
@property NSMutableArray *animationValues;
@end

@implementation EnemyShip

-(id) initWithPosition:(CGPoint)position imageFile:(NSString*)file playerShip:(Ship*)playerShip andAllENemyLasersArray:(NSMutableArray *)allEnemyLasers
{
    self = [super init];

    if (self) {
        self.playerShip = playerShip;
        self.allEnemyLasers = allEnemyLasers;

        UIImage *shipImage = [UIImage imageNamed:file];
        CGFloat width = shipImage.size.width;
        CGFloat height= shipImage.size.height;
        
        self.bounds = CGRectMake(0.0, 0.0, width, height);
        self.position = position;
        self.zPosition = 1000;
        self.contents = (__bridge id)([shipImage CGImage]);
        
        [self initializeAnimationPoints];
    }
    return self;
}

- (void)initializeAnimationPoints
{
    self.animationValues = [NSMutableArray new];
    
    //  first leg of animation
    double (^leg1)(double x) = ^double(double x) {
        return x;
    };
    
    for (float x = self.position.x; x < self.position.x + 150; x++) {
        CGPoint point = CGPointMake(x, leg1(x) + self.position.y);
        [self.animationValues addObject:[NSValue valueWithCGPoint:point]];
    }
    
    CGPoint transitionPoint1 = [[self.animationValues lastObject] CGPointValue];
    double constant2 = transitionPoint1.y + transitionPoint1.x;
        
    //  second leg of animation
    double (^leg2)(double x) = ^double(double x) {
        return (constant2 - x);
    };

    for (float x = transitionPoint1.x; x > 0; x--) {
        CGPoint point = CGPointMake(x, leg2(x));
        [self.animationValues addObject:[NSValue valueWithCGPoint:point]];
    }

}

- (void)animate
{
    if (!self.animationValues)
        [self initializeAnimationPoints];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = self.animationValues;

    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.delegate = self;
    self.animationGroup.animations = [NSArray arrayWithObject:animation];
    self.animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    self.animationGroup.duration = 10.0;
    [self addAnimation:self.animationGroup forKey:@"animateMotion"];
}

- (CGPoint)newRandomDirection
{
    float x = arc4random() % (int)self.superlayer.bounds.size.width;
    float y = -50;
    return CGPointMake(x, y);
}

- (void)keepAsteroidWithinView
{
    double viewWidth = self.superlayer.bounds.size.width;
    double viewHeight = self.superlayer.bounds.size.height;
    
    if (([self.presentationLayer position].y > viewHeight) || ([self.presentationLayer position].x < 0) || ([self.presentationLayer position].x > viewWidth) ) {
        self.position = CGPointMake(self.superlayer.bounds.size.width/2.0, 0.0);
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (flag == NO)
        return;
    
    [self attack];
    [self animate];
}

- (void)unsetAnimationDelegate
{
    self.animationGroup.delegate = nil;
}

- (void)attack
{
    // Shoot at the player's current presentation position
    NSLog(@"Attacking player");

    
    // Problem:  if the enemyShip is already itself the delegate for its motion animation, who will be the delegate for its laser animation?
    
    
    
}

@end
