//
//  MainView.h
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameView : UIView
@property (strong,nonatomic) NSMutableArray *allAsteroids;
@property (strong,nonatomic) NSMutableArray *allLaserBlasts;
@property (strong,nonatomic) NSMutableArray *allEnemyShips;
- (void)startCollisionDetectorLoop;
@end
