//
//  LaserBlast.m
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "LaserBlast.h"
#import <QuartzCore/QuartzCore.h>

@interface LaserBlast()
@property LaserType laserType;
@property (weak,nonatomic) NSMutableArray *laserArrayContainer;
@property CGPoint targetPosition;
@property CABasicAnimation *animation;
@end

@implementation LaserBlast

- (id)initWithPosition:(CGPoint)startPosition targetPosition:(CGPoint)targetPosition laserType:(LaserType)type AndLaserArrayContainer:(NSMutableArray*) laserArrayContainer
{
    self = [super init];

    if (!self)
        return nil;
    
    UIImage *laserImage;
    self.laserType = type;
    
    // If the laser type is player then create the playerLaser, otherwise create the green enemyLaser
    if (type == 0) {
        self.bounds = CGRectMake(0.0, 0.0, 5.0, 50.0);
        self.frame = CGRectMake(0,0, 5, 50.0);
        self.position = CGPointMake(startPosition.x, startPosition.y - 50);   // The 50 offset is to make sure the laser doesn't start from behind the ship, but seems to appear from the ship.
        NSString *fileName  = [NSString stringWithFormat:@"laser.png"];
        laserImage = [UIImage imageNamed:fileName];
    }
    else {
        self.bounds = CGRectMake(0.0, 0.0, 20.0, 30.0);
        self.frame = CGRectMake(0.0, 0.0, 20.0, 30.0);
        self.position = startPosition;
        NSString *fileName = [NSString stringWithFormat:@"greenLaser.png"];
        laserImage = [UIImage imageNamed:fileName];
        self.targetPosition = targetPosition;
    }
        
    self.laserArrayContainer = laserArrayContainer;
    self.zPosition = 500;
    self.contents = (__bridge id)([laserImage CGImage]);

    return self;
}

- (CGFloat)angleBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2
{
    CGFloat height = point2.y - point1.y;
    CGFloat width = point2.x - point1.x;
    CGFloat rads = atan(height/width);
    return (rads + M_PI/2.0);
    //return radiansToDegrees(rads);
}

- (void)animate
{
    //  Animate a player's laserBlast
    if (self.laserType == player) {
        // Player's laser can only go straight up, thus its destination x coordinate is the same
        CGPoint laserEndPoint = CGPointMake(self.position.x, -50);
        self.animation = [CABasicAnimation animationWithKeyPath:@"position"];
        self.animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        self.animation.fromValue = [NSValue valueWithCGPoint:self.position];
        self.animation.toValue = [NSValue valueWithCGPoint:laserEndPoint];
        self.animation.repeatCount = 0;
        self.animation.duration = 0.75;
        self.animation.delegate = self;
        [self addAnimation:self.animation forKey:@"position"];
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.position = laserEndPoint;
        [CATransaction commit];
    }
    //  Animate an enemy laserBlast
    else {
        //  If player ship is not aligned with laserBlast origin, add a rotation transform to make the laser orient toward the ship
        if (self.targetPosition.x != self.position.x) {
            self.transform = CATransform3DMakeRotation([self angleBetweenPoint1:self.position andPoint2:self.targetPosition], 0.0, 0.0, 1.0);
        }
        
        //  Calculate an off-screen end point such that the path to it passes through the player's ship position
       
        self.animation = [CABasicAnimation animationWithKeyPath:@"position"];
        self.animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        self.animation.fromValue = [NSValue valueWithCGPoint:self.position];
        self.animation.toValue = [NSValue valueWithCGPoint:self.targetPosition];
        self.animation.repeatCount = 0;
        self.animation.duration = 1.5;
        self.animation.delegate = self;
        [self addAnimation:self.animation forKey:@"position"];

        [CATransaction begin];
        [CATransaction setDisableActions:YES];      // Turn off implicit animation
        self.position = self.targetPosition;
        [CATransaction commit];
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (flag == NO) {
        return;
    }
    
    [self removeFromSuperlayer];
    [self removeFromLaserArrayContainer];
}

- (void)removeFromLaserArrayContainer
{
    [self.laserArrayContainer removeObject:self];
    //  NSLog(@"laser container size: %u", [self.laserArrayContainer count]);
}

- (void)unsetAnimationDelegate
{
    // 
    self.animation.delegate = nil;
}

@end
