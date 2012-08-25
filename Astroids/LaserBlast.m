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
@end

@implementation LaserBlast

- (id)initWithPosition:(CGPoint)position
{
    self = [super init];
        
    if (self) {
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
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSValue valueWithCGPoint:self.position];
    animation.toValue = [NSValue valueWithCGPoint:laserEndPoint];
    animation.repeatCount = 1;
    animation.duration = 0.5;
    animation.delegate = self;  // the handler will be   " - (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag "
    [self addAnimation:animation forKey:@"position"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    [self removeFromSuperlayer];
}

@end
