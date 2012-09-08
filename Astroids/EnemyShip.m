//
//  EnemyShip.m
//  Astroids
//
//  Created by Robert Carter on 8/27/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "EnemyShip.h"

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
    }
    return self;
}

- (void)animate
{

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

- (void)attack
{
    // Shoot at the player's current presentation position
    
    // Add the 
}

@end
