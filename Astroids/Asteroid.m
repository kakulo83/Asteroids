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
@property (strong, nonatomic) CAAnimationGroup *animation;
@property (strong, nonatomic) CAKeyframeAnimation *destructionAnimation;
@property (strong, nonatomic) NSMutableArray *destructionImages;
@end

@implementation Asteroid

- (id)initWithPosition:(CGPoint)position andEndPosition:(CGPoint)endPosition
{
    self = [super init];
    
    if (!self)
        return nil;
    
    CGFloat dimension = 15 + arc4random() % (int)50;
    self.bounds = CGRectMake(0.0, 0.0, dimension, dimension);
    self.position = position;
    self.endPosition = endPosition;
    self.zPosition = 2000;
    NSString *fileName = [NSString stringWithFormat:@"asteroid.png"];
    UIImage *shipImage = [UIImage imageNamed:fileName];
    self.contents = (__bridge id)([shipImage CGImage]);
    [self createDestructionImageArray];

    return self;
}

- (void)createDestructionImageArray
{
    NSMutableArray *destructionImages = [NSMutableArray new];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"asteroidExplosion0.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"asteroidExplosion1.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"asteroidExplosion2.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"asteroidExplosion3.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"asteroidExplosion4.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"asteroidExplosion5.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"asteroidExplosion6.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"asteroidExplosion7.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"asteroidExplosion8.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"asteroidExplosion9.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"asteroidExplosion10.png"] CGImage]];
    self.destructionImages = destructionImages;
}

- (void)animate
{
    CGFloat x = arc4random() % (int)self.superlayer.bounds.size.width;
    CGFloat y = -30.0;
        
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
 
    double animationDuration = 2 + arc4random() % (int)12;
    
    //  Combine rotate and translate animation into one
    self.animation = [CAAnimationGroup animation];
    [self.animation setAnimations:[NSArray arrayWithObjects:translate, rotate , nil]];
    [self.animation setDuration:animationDuration];
    [self.animation setRemovedOnCompletion:YES];
    [self.animation setFillMode:kCAFillModeForwards];
    [self.animation setDelegate:self];
    [self.animation setValue:@"moveAndRotate" forKey:@"name"];
    [self addAnimation:self.animation forKey:@"moveAndRotate"];
}

- (void)animateDestruction
{
    self.destructionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    [self.destructionAnimation setCalculationMode:kCAAnimationDiscrete];
    [self.destructionAnimation setDelegate:self];
    [self.destructionAnimation setDuration:1.0f];
    [self.destructionAnimation setRepeatCount:0];
    [self.destructionAnimation setValues:self.destructionImages];
    [self.destructionAnimation setValue:@"destruction" forKey:@"name"];
    [self addAnimation:self.destructionAnimation forKey:@"destruction"];
}

- (CGPoint)newRandomEndPosition
{
    float newX = arc4random() % (int)self.superlayer.bounds.size.width;
    float newY = self.superlayer.bounds.size.height;
    return CGPointMake(newX, newY);
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (flag == NO)
        return;
    
    if ([[theAnimation valueForKey:@"name"] isEqual:@"moveAndRotate"] && flag) {
        [self animate];
    }
    else {
        [self.destructionAnimation setDelegate:nil];
        [self removeFromSuperlayer];
    }
}

- (void)destroyAsteroid
{
    //  set the current Model position of the asteroid to the presentation position
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.position = [self.presentationLayer position];
    [CATransaction commit];
    
    //  grab the presentationLayer's current angle of rotation
    CGFloat rotationAngle = [[self.presentationLayer valueForKeyPath:@"transform.rotation"] floatValue];
 
    //  stop the current animation
    [self removeAnimationForKey:@"moveAndRotate"];
    
    //  set the current Model rotation to the value of the presentation rotation
    self.transform = CATransform3DMakeRotation(rotationAngle, 0.0, 0.0, 1.0);
    
    //  animate the destruction sequence
    [self animateDestruction];
    
    self.contents = [self.destructionImages lastObject];
}

- (void)unsetAnimationDelegate
{
    //  NOTE: an animation delegate is a STRONG pointer type, to avoid a memory retain cycle make sure to destroy the delegate or the object that is being animated will be retained.
    self.animation.delegate = nil;
}

@end
