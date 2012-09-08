//
//  LaserBlast.h
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface LaserBlast : CALayer
@property (weak,nonatomic) NSMutableArray *allLaserBlasts;
-(id) initWithPosition:(CGPoint)position AndLaserArrayContainer:(NSMutableArray*) allLaserBlasts;
- (void)animate;
- (void)unsetAnimationDelegate;
@end
