//
//  EnemyShip.m
//  Astroids
//
//  Created by Robert Carter on 8/27/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "EnemyShip.h"
#import "Ship.h"
#import "LaserBlast.h"

@interface EnemyShip()
@property Ship *playerShip;
@property (weak, nonatomic) NSMutableArray *allEnemyLasers;
@property CGPoint newPosition;
@property CAAnimationGroup *animationGroup;

@end

@implementation EnemyShip

- (id)initWithPosition:(CGPoint)position shipType:(EnemyShipType)shipType playerShip:(Ship*)playerShip andAllENemyLasersArray:(NSMutableArray *)allEnemyLasers
{
    self = [super init];

    if (!self)
        return nil;
    
    self.playerShip = playerShip;
    self.allEnemyLasers = allEnemyLasers;

    //  Set the content image depending on the enemy ship type
    UIImage *enemyShipImage;
    switch (shipType) {
        case Tie: {
            enemyShipImage = [UIImage imageNamed:@"tieFighter.png"];
        }
            break;
        case Interceptor: {
            enemyShipImage = [UIImage imageNamed:@"tieInterceptor.png"];
        }
            break;
        case Bomber: {
            enemyShipImage = [UIImage imageNamed:@"tieBomber.png"];
        }
            break;
        default:
            break;
    }

    CGFloat width = enemyShipImage.size.width;
    CGFloat height= enemyShipImage.size.height;
    
    self.bounds = CGRectMake(0.0, 0.0, width, height);
    self.position = position;
    self.zPosition = 1000;
    self.contents = (__bridge id)([enemyShipImage CGImage]);

    return self;
}

//- (NSArray *)createAnimationPathValues
//{
//    NSMutableArray *animationPathValues = [NSMutableArray new];
//    
//    //  Create a new end-point within the screen
//    CGFloat endPointX = arc4random() % (int)self.superlayer.bounds.size.width;
//    CGFloat endPointY = arc4random() % (int)self.superlayer.bounds.size.height;
//
//    if ([self.presentationLayer position].x < endPointX) {
//        for (float x = [self.presentationLayer position].x; x < endPointX; x++ ) {
//            
//        }
//    }
//    
//    //  first leg of animation
//    double (^leg1)(double x) = ^double(double x) {
//        return x;
//    };
//    
//    for (float x = self.position.x; x < self.position.x + 150; x++) {
//        CGPoint point = CGPointMake(x, leg1(x) + self.position.y);
//        [animationPathValues addObject:[NSValue valueWithCGPoint:point]];
//    }
//    
//    CGPoint transitionPoint1 = [[animationPathValues lastObject] CGPointValue];
//    double constant2 = transitionPoint1.y + transitionPoint1.x;
//        
//    //  second leg of animation
//    double (^leg2)(double x) = ^double(double x) {
//        return (constant2 - x);
//    };
//
//    for (float x = transitionPoint1.x; x > 0; x--) {
//        CGPoint point = CGPointMake(x, leg2(x));
//        [animationPathValues addObject:[NSValue valueWithCGPoint:point]];
//    }
//    return animationPathValues;
//}

- (void)animate
{
    //  NSArray *animationPathValues = [self createAnimationPathValues];
   
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    animation.values = [NSArray arrayWithObject:[NSValue valueWithCGPoint:newEndPosition]];
//
//    self.animationGroup = [CAAnimationGroup animation];
//    self.animationGroup.delegate = self;
//    self.animationGroup.animations = [NSArray arrayWithObject:animation];
//    self.animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    self.animationGroup.duration = 10.0;
//    [self addAnimation:self.animationGroup forKey:@"animateMotion"];

    CGFloat newX = arc4random() % (int)self.superlayer.bounds.size.width;
    CGFloat newY = arc4random() % (int)self.superlayer.bounds.size.height;
    CGPoint newEndPosition = CGPointMake(newX, newY);
    
    self.newPosition = newEndPosition;
    
    CABasicAnimation *enemyAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    enemyAnimation.delegate = self;
    enemyAnimation.duration = 5.0;
    enemyAnimation.repeatCount = 0;
    enemyAnimation.fromValue = [NSValue valueWithCGPoint:self.position];
    enemyAnimation.toValue = [NSValue valueWithCGPoint:newEndPosition];
    [self addAnimation:enemyAnimation forKey:@"movement"];
}

- (void)animateDestruction
{
    
}

- (void)keepShipWithinView
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
    
    //  Update the position
    self.position = self.newPosition;

    [self attack];
    [self animate];
}

- (void)unsetAnimationDelegate
{
    self.animationGroup.delegate = nil;
}

- (void)attack
{
    //  NSLog(@"Attacking player");
    
    //  Shoot at the player's current presentation position
    LaserType laserType = enemy;
    LaserBlast *laserBlast = [[LaserBlast alloc] initWithPosition:self.position targetPosition:self.playerShip.position laserType:laserType AndLaserArrayContainer:self.allEnemyLasers];
    [self.superlayer addSublayer:laserBlast];
    
    //  Add enemy laser blast to view's array of enemyLaserBlasts
    [self.allEnemyLasers addObject:laserBlast];
    
    [laserBlast animate];
}

@end