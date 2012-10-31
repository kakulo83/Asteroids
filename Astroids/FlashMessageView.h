//
//  LevelUpView.h
//  Astroids
//
//  Created by Robert Carter on 9/11/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashMessageView : UIView
- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)levelText;
- (void)scaleUp;
@end
