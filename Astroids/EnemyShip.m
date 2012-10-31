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
@property CABasicAnimation *movementAnimation;
@property CAKeyframeAnimation *destructionAnimation;
@property NSMutableArray *destructionImages;
@end

@implementation EnemyShip

- (id)initWithPosition:(CGPoint)position shipType:(EnemyShipType)shipType playerShip:(Ship*)playerShip andAllENemyLasersArray:(NSMutableArray *)allEnemyLasers
{
    self = [super init];

    if (!self)
        return nil;
    
    self.playerShip = playerShip;
    self.allEnemyLasers = allEnemyLasers;
    self.isDestroyed = NO;
    [self createDestructionImageArray];

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

- (void)createDestructionImageArray
{
    NSMutableArray *destructionImages = [NSMutableArray new];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion0.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion1.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion2.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion3.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion4.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion5.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion6.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion7.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion8.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion9.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion10.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion11.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion12.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion13.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion14.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion15.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion16.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion17.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion18.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion19.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion20.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion21.png"] CGImage]];
    [destructionImages addObject:(id)[[UIImage imageNamed:@"explosion22.png"] CGImage]];
    
    self.destructionImages = destructionImages;
}

- (void)animate
{
    CGFloat newX = arc4random() % (int)self.superlayer.bounds.size.width;
    CGFloat newY = arc4random() % (int)self.superlayer.bounds.size.height;
    CGPoint newRandomPosition = CGPointMake(newX, newY);
    
    self.newPosition = newRandomPosition;
    
    self.movementAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    self.movementAnimation.delegate = self;
    self.movementAnimation.duration = 5.0;
    self.movementAnimation.repeatCount = 0;
    self.movementAnimation.fromValue = [NSValue valueWithCGPoint:self.position];
    self.movementAnimation.toValue = [NSValue valueWithCGPoint:self.newPosition];
    [self.movementAnimation setValue:@"movement" forKey:@"position"];
    [self addAnimation:self.movementAnimation forKey:@"movement"];

    //  Update the position
    [CATransaction begin];
    [CATransaction setDisableActions:YES];      // Turn off implicit animation
    self.position = self.newPosition;
    [CATransaction commit];
}

- (void)animateDestruction
{
    //  NSLog(@"Animating enemy ship destruction");
    
    self.destructionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    [self.destructionAnimation setCalculationMode:kCAAnimationDiscrete];

    [self.destructionAnimation setDelegate:self];
    [self.destructionAnimation setDuration:2.0f];
    [self.destructionAnimation setRepeatCount:0];
    [self.destructionAnimation setValues:self.destructionImages];
    [self addAnimation:self.destructionAnimation forKey:@"destruction"];
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
    //  AnimationDidStop is only interrupted when the ship has been destroyed
    if (flag == NO) {
        return;
    }
    
    if ([[theAnimation valueForKey:@"position"] isEqual:@"movement"] && flag) {
        [self attack];
        [self animate];
    }
    else {
        self.destructionAnimation.delegate = nil;
        [self removeFromSuperlayer];
    }
}

- (void)destroyShip
{
    //  set the current Model position of the enemy ship to the presentation position
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.position = [self.presentationLayer position];
    [CATransaction commit];
    
    //  stop the current animation
    [self removeAnimationForKey:@"movement"];
        
    //  animate the destruction sequence
    [self animateDestruction];
    
    self.contents = [self.destructionImages lastObject];
}

//- (void)unsetAnimationDelegate
//{
//    NSLog(@"Removing enemy ship's delegate");
//    self.movementAnimation.delegate = nil;
//    self.destructionAnimation.delegate = nil;
//}

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