//
//  CMMConnectionViewController.h
//  CMMobile
//
//  Created by Victoria Teufel on 20.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import <UIKit/UIKit.h>

#define START_ANIMATION_DURATION 1
#define END_ANIMATION_DURATION 2
#define ANIMATION_PAUSE_DURATION 1
#define DISMISS_ANIMATION_DURATION 2

@interface CMMConnectionViewController : UIViewController
{
    UIImageView* _plugImageView;
    UIImageView* _pinsImageView;
    
    UIImageView* _socketImageView;
}

@end
