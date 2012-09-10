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

@interface EnemyShip : CALayer
-(id) initWithPosition:(CGPoint)position imageFile:(NSString*)file playerShip:(Ship*)playerShip andAllENemyLasersArray:(NSMutableArray *)allEnemyLasers;
-(void) animate;
- (void)unsetAnimationDelegate;
@end
