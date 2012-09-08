//
//  MainViewController.h
//  Astroids
//
//  Created by Robert Carter on 8/23/12.
//  Copyright (c) 2012 Robert Carter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
//  Define a ShipType enum that encapsulates valid user ship selections
typedef enum ShipType { xwing, falcon, ywing, twing } ShipType;
@property ShipType shipType;
@end
