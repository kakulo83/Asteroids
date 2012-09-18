//
//  LevelUpView.m
//  Astroids
//
//  Created by Robert Carter on 9/11/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import "FlashMessageView.h"
#import <QuartzCore/QuartzCore.h>

@interface FlashMessageView()
@property (strong, nonatomic) NSString *levelText;
@end


@implementation FlashMessageView

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)levelText
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];  //[UIColor colorWithRed:0.0 green:0.2 blue:1.0 alpha:5.0];
        self.levelText = levelText;
    }
    return self;
}

- (void)scaleUp
{
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 25.0)];
    levelLabel.backgroundColor = [UIColor blackColor];
    levelLabel.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    levelLabel.text = self.levelText;
    levelLabel.textColor = [UIColor blueColor];
    levelLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:levelLabel];
    
    // Animate view by scaling it from small to large
    [UIView animateWithDuration:2.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.center = CGPointMake(self.superview.bounds.size.width/2.0, self.superview.bounds.size.height/2.0);
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2.0, 2.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
