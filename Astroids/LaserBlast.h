//
//  LaserBlast.h
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef enum LaserType { player, enemy } LaserType;

@interface LaserBlast : CALayer
- (id)initWithPosition:(CGPoint)startPosition targetPosition:(CGPoint)targetPosition laserType:(LaserType)type AndLaserArrayContainer:(NSMutableArray*) laserArrayContainer;
- (void)animate;
- (void)unsetAnimationDelegate;
@end
