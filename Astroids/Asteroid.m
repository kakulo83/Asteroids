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
@property CGPoint direction;
@end

@implementation Asteroid

- (id)initWithPosition:(CGPoint)position andDirection:(CGPoint)direction
{
    self = [super init];
        
    if (self) {
        self.bounds = CGRectMake(0.0, 0.0, 70.0, 70.0);
        self.position = position;
        self.direction = direction;
        self.zPosition = 1000;
        NSString *fileName = [NSString stringWithFormat:@"asteroid.png"];
        UIImage *shipImage = [UIImage imageNamed:fileName];
        self.contents = (__bridge id)([shipImage CGImage]);
    }
    return self;
}

- (void)animate
{
    //  If the asteroid has moved off-screen, redraw it at the top again and give it a new path direction
    if (self.position.y >= self.superlayer.bounds.size.height) {
        [self setDirection:[self newRandomDirection]];
        [self setPosition:CGPointMake(self.superlayer.bounds.size.width/2.0, 0.0)];
    }
    
    CGPoint start = [self position];
    CGPoint finish = CGPointMake(start.x + self.direction.x, start.y + self.direction.y);
    
    //  Make sure to update the position of the asteroid so that when the next animation is called (see animationDidStop method) the current position is equal to that of the end of the previous animations
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self setPosition:finish];
    [CATransaction commit];
    
    CABasicAnimation *translate = [CABasicAnimation animationWithKeyPath:@"position"];
    [translate setFromValue:[NSValue valueWithCGPoint:start]];
    [translate setToValue:[NSValue valueWithCGPoint:finish]];
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [rotate setToValue:[NSNumber numberWithFloat:M_PI * 2.0]];
 
    //  Combine both the rotate and translate animation into one
    CAAnimationGroup *anim = [CAAnimationGroup animation];
    [anim setAnimations:[NSArray arrayWithObjects:translate, rotate, nil]];
    [anim setDuration:3.0];
    [anim setRemovedOnCompletion:NO];
    [anim setFillMode:kCAFillModeForwards];
    [anim setDelegate:self];
    [self addAnimation:anim forKey:nil];
}

- (CGPoint)newRandomDirection
{
    float deltaX = arc4random() % 39 - 20;
    float deltaY = arc4random() % 79 - 40;
    return CGPointMake(deltaX, deltaY);
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    [self animate];
}

- (void)destroy
{
    [self removeFromSuperlayer];
}

@end
