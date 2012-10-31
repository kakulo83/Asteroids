//
//  EnemyShip.h
//  Astroids
//
//  Created by Robert Carter on 8/27/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class GameView;
@class Ship;
typedef enum { Tie, Interceptor, Bomber } EnemyShipType;

@interface EnemyShip : CALayer
@property BOOL isDestroyed;
- (id) initWithPosition:(CGPoint)position shipType:(EnemyShipType)shipType playerShip:(Ship *)playerShip andAllENemyLasersArray:(NSMutableArray *)allEnemyLasers;
- (void)animate;
- (void)destroyShip;
- (void)animateDestruction;
//- (void)unsetAnimationDelegate;
@end
