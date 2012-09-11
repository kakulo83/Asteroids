//
//  Asteroid.m
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "Asteroid.h"

@interface Asteroid()
{

}
@property CGPoint endPosition;
@property CAAnimationGroup *animation;
@end

@implementation Asteroid

- (id)initWithPosition:(CGPoint)position andEndPosition:(CGPoint)endPosition
{
    self = [super init];
    
    if (self) {
        self.bounds = CGRectMake(0.0, 0.0, 70.0, 70.0);
        self.position = position;
        self.endPosition = endPosition;
        self.zPosition = 2000;
        NSString *fileName = [NSString stringWithFormat:@"asteroid.png"];
        UIImage *shipImage = [UIImage imageNamed:fileName];
        self.contents = (__bridge id)([shipImage CGImage]);
    }
    return self;
}

- (void)animate
{
    CGFloat x = arc4random() % (int)self.superlayer.bounds.size.width;
    CGFloat y = -10.0;
        
    self.position = CGPointMake(x,y);
    self.endPosition = [self newRandomEndPosition];
    
    //  Create translation animation
    CABasicAnimation *translate = [CABasicAnimation animationWithKeyPath:@"position"];
    [translate setFromValue:[NSValue valueWithCGPoint:self.position]];
    [translate setToValue:[NSValue   valueWithCGPoint:self.endPosition]];
    
    //  Create rotation animation
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];

    //  Make some asteroids rotate clockwise and others counterclockwise by generating a random +1 / -1  rotation multiplier
    int binaryDice = arc4random() % 2;
    double rotationSign;
    if (binaryDice == 1)
        rotationSign = -1.0;
    else
        rotationSign = 1.0;
        
    [rotate setToValue:[NSNumber numberWithFloat:M_PI * 2.0 * rotationSign]];
 
    //  Combine rotate and translate animation into one
    self.animation = [CAAnimationGroup animation];
    [self.animation setAnimations:[NSArray arrayWithObjects:translate, rotate , nil]];
    [self.animation setDuration:12.0];
    [self.animation setRemovedOnCompletion:YES];
    [self.animation setFillMode:kCAFillModeForwards];
    [self.animation setDelegate:self];
    [self addAnimation:self.animation forKey:@"movement"];
}

- (CGPoint)newRandomEndPosition
{
    float newX = arc4random() % (int)self.superlayer.bounds.size.width;
    float newY = self.superlayer.bounds.size.height;
    return CGPointMake(newX, newY);
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    //  When the asteroid is removed from the superlayer (view) animationDidStop is called
    if (flag == NO)
        return;

    [self animate];
}

- (void)unsetAnimationDelegate
{
    //  NOTE: an animation delegate is a STRONG pointer type, to avoid a memory retain cycle make sure to destroy the delegate or the object that is being animated will be retained.
    self.animation.delegate = nil;
}

@end
