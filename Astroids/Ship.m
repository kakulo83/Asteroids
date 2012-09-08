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

-(id) initWithPosition:(CGPoint)position andImageFile:(NSString*)file
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

@end
