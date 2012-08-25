//
//  LaserBlast.h
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface LaserBlast : CALayer
-(id) initWithPosition:(CGPoint)position;
- (void)animate;
@end
