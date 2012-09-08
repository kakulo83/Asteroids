//
//  EnemyShip.m
//  Astroids
//
//  Created by Robert Carter on 8/27/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "EnemyShip.h"

@interface EnemyShip() {
    
}
@property CAAnimationGroup *animationGroup;
@property NSMutableArray *animationValues;

@end

@implementation EnemyShip

-(id) initWithPosition:(CGPoint)position imageFile:(NSString*)file
{
    self = [super init];

    if (self) {
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
        CGPoint point = CGPointMake(x, leg1(x));
        [self.animationValues addObject:[NSValue valueWithCGPoint:point]];
    }
    
    CGPoint transitionPoint1 = [[self.animationValues lastObject] CGPointValue] ;
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
    float deltaX = arc4random() % 39 - 20;
    float deltaY = arc4random() % 79 - 40;
    return CGPointMake(deltaX, deltaY);
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
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
    // Add the h
}

@end
