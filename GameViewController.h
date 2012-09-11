//
//  MainViewController.h
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum { empty, falcon, xwing, twing, ywing } ShipType;
typedef enum { first, second, third } GameLevel;

@interface GameViewController : UIViewController
@property ShipType shipType;
@end
