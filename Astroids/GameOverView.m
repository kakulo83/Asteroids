//
//  GameOverView.m
//  Astroids
//
//  Created by Robert Carter on 9/10/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "GameOverView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GameOverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    // Initialization code
//    UIImage *gameOverImage = [UIImage imageNamed:@"gameOver.png"];
//    self.layer.contents = (__bridge id)([gameOverImage CGImage]);
    self.backgroundColor = [UIColor grayColor];
    self.bounds = frame;
    
    return self;
}

- (void)animate
{
    // Use a CAAnimation to change the view's opacity from 0 to 1.0 over 1 second
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
