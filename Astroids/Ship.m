//
//  Ship.m
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//
    
#import "Ship.h"
#import <QuartzCore/QuartzCore.h>

@interface Ship()
{

}
@end

@implementation Ship

- (id)initWithPosition:(CGPoint)position
{
    self = [super init];
    
    self.bounds = CGRectMake(0.0, 0.0, 70.0, 70.0);
    self.position = position;
    self.zPosition = 1000;
    
    if (self) {
        NSString *fileName = [NSString stringWithFormat:@"ship.png"];
        UIImage *shipImage = [UIImage imageNamed:fileName];
        self.contents = (__bridge id)([shipImage CGImage]);
    }
    return self;
}

@end
