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

- (id)initWithPosition:(CGPoint)position andImageFile:(NSString*)file
{
    self = [super init];
        
    if (!self)
        return nil;
    
    UIImage *shipImage = [UIImage imageNamed:file];
    CGFloat width = shipImage.size.width;
    CGFloat height= shipImage.size.height;
    self.bounds = CGRectMake(0.0, 0.0, width, height);
    self.shadowColor = [[UIColor blackColor] CGColor];
    self.shadowOpacity = 1.0;
    self.shadowRadius = 10.0;
    self.shadowOffset = CGSizeMake(10.0f, 10.0f);
    self.position = position;
    self.zPosition = 1000;
    self.contents = (__bridge id)([shipImage CGImage]);

    return self;
}

- (CGRect)collisionRectangle
{
    CGFloat presentationX = [self.presentationLayer position].x;
    CGFloat presentationY = [self.presentationLayer position].y;
    
    CGFloat layerWidth = self.bounds.size.width;
    CGFloat layerHeight= self.bounds.size.height;
    
    return CGRectMake(presentationX, presentationY, layerWidth * .30, layerHeight * .30);
}

@end
