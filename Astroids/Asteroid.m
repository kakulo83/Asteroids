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
        self.zPosition = 1000;
        NSString *fileName = [NSString stringWithFormat:@"asteroid.png"];
        UIImage *shipImage = [UIImage imageNamed:fileName];
        self.contents = (__bridge id)([shipImage CGImage]);
    }
    return self;
}

- (void)animate
{
    //  Create translation animation
    CABasicAnimation *translate = [CABasicAnimation animationWithKeyPath:@"position"];
    [translate setFromValue:[NSValue valueWithCGPoint:self.position]];
    [translate setToValue:[NSValue   valueWithCGPoint:self.endPosition]];
    
    //  Create rotation animation
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [rotate setToValue:[NSNumber numberWithFloat:M_PI * 2.0]];
 
    //  Combine rotate and translate animation into one
    self.animation = [CAAnimationGroup animation];
    [self.animation setAnimations:[NSArray arrayWithObjects:translate, rotate , nil]];
    [self.animation setDuration:12.0];
    [self.animation setRemovedOnCompletion:YES];
    [self.animation setFillMode:kCAFillModeForwards];
    [self.animation setDelegate:self];
    [self addAnimation:self.animation forKey:nil];
}

- (void)keepAsteroidWithinView
{
    double viewWidth = self.superlayer.bounds.size.width;
    double viewHeight = self.superlayer.bounds.size.height;
          
    if (([self.presentationLayer position].y > viewHeight) || ([self.presentationLayer position].x < 0) || ([self.presentationLayer position].x > viewWidth) ) {
        self.position = CGPointMake(self.superlayer.bounds.size.width/2.0, 0.0);
        self.endPosition = [self newRandomEndPosition];
    }
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
    
    [self keepAsteroidWithinView];
    [self animate];
}

- (void)unsetAnimationDelegate
{
    self.animation.delegate = nil;
}


@end
