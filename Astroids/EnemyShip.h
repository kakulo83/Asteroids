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

@interface EnemyShip : CALayer
@property (weak, nonatomic) NSMutableArray* allLaserBlasts;
-(id) initWithPosition:(CGPoint)position imageFile:(NSString*)file;
-(void) animate;
@end
