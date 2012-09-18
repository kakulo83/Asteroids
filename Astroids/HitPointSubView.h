//
//  PlayerHitPointSubView.h
//  Astroids
//
//  Created by Robert Carter on 9/17/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HitPointSubView : UIView
@property int playerHitPoints;
- (id)initWithFrame:(CGRect)frame maxHP:(int)maxHitPoints andPlayerHP:(int)playerHitPoints;
- (void)updateView;
@end
