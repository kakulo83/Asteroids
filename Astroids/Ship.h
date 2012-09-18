//
//  Ship.h
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface Ship : CALayer
@property int hitPoints;
-(id) initWithPosition:(CGPoint)position andImageFile:(NSString*)file;
- (CGRect)collisionRectangle;
@end
