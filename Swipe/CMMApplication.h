//
//  CMMApplication.h
//  CMMobile
//
//  Created by Victoria Teufel on 11.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMMSwipe.h"
#import "CMMGestureRecognizerDelegate.h"

@interface CMMApplication : UIApplication
{
    CMMSwipe* _currentSwipe;
}

@property(weak, nonatomic) id<CMMGestureRecognizerDelegate> gestureDelegate;

@end
