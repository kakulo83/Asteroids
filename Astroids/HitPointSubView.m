//
//  PlayerHitPointSubView.m
//  Astroids
//
//  Created by Robert Carter on 9/17/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "HitPointSubView.h"
#import <QuartzCore/QuartzCore.h>

@interface HitPointSubView() {
    
}
@property int maxHitPoints;
@end


@implementation HitPointSubView

- (id)initWithFrame:(CGRect)frame maxHP:(int)maxHitPoints andPlayerHP:(int)playerHitPoints
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.maxHitPoints = maxHitPoints;
        self.playerHitPoints = playerHitPoints;
    }
    return self;
}

- (void)updateView
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor greenColor] set];
    CGContextSetLineWidth(context,  15.0);
    
    CGContextMoveToPoint(context, 0.0, (self.maxHitPoints - self.playerHitPoints) * self.maxHitPoints);
    CGContextAddLineToPoint(context, 0.0, self.bounds.size.height);
    CGContextStrokePath(context);
}

@end
