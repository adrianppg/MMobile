//
//  CMMGestureRecognizerDelegate.h
//  CMMobile
//
//  Created by Victoria Teufel on 11.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMMSwipe.h"

@protocol CMMGestureRecognizerDelegate <NSObject>

- (void)didRecognizeSwipe:(CMMSwipe*)swipe;

@end
