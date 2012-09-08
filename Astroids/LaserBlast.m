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
{
    
}
@property CABasicAnimation *animation;
@end

@implementation LaserBlast

- (id)initWithPosition:(CGPoint)position AndLaserArrayContainer:(NSMutableArray*) allLaserBlasts
{
    self = [super init];
        
    if (self) {
        self.allLaserBlasts = allLaserBlasts;
        self.bounds = CGRectMake(0.0, 0.0, 70.0, 70.0);
        self.frame = CGRectMake(0,0, 20, 100);
        self.position = CGPointMake(position.x, position.y - 50);   // The 50 offset is to make sure the laser doesn't start from behind the ship, but seems to appear from the ship.
        self.zPosition = 500;

        // Set the layer's image content
        NSString *fileName  = [NSString stringWithFormat:@"laser.png"];
        UIImage *laserImage = [UIImage imageNamed:fileName];
        self.contents = (__bridge id)([laserImage CGImage]);
    }
    return self;
}

- (void)animate
{
    //  Animate its movement so it goes up the screen to the viscious evil asteroid (piu piu)

    CGPoint laserEndPoint = CGPointMake(self.position.x, -50);
    
    // Basically the same animation procedures as the space background scrolling, except only called once
    self.animation = [CABasicAnimation animationWithKeyPath:@"position"];
    self.animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    self.animation.fromValue = [NSValue valueWithCGPoint:self.position];
    self.animation.toValue = [NSValue valueWithCGPoint:laserEndPoint];
    self.animation.repeatCount = 1;
    self.animation.duration = 0.5;
    self.animation.delegate = self;
    [self addAnimation:self.animation forKey:@"position"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (flag == NO) {
        return;
    }
    
    [self removeFromSuperlayer];
    [self removeFromViewArray];
}

- (void)removeFromViewArray
{
    [self.allLaserBlasts removeObject:self];
}

- (void)unsetAnimationDelegate
{
    self.animation.delegate = nil;
}

@end
