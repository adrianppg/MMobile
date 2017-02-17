//
//  CMMSwipe.m
//  CMMobile
//
//  Created by Victoria Teufel on 11.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import "CMMSwipe.h"

@implementation CMMSwipe

- (CMMSwipeDirection)swipeDirection
{
    if (_start.x == 0) {
        return CMMCSwipeDirectionLeftToRight;
    }
    else if (_start.x == 1) {
        return CMMSwipeDirectionRightToLeft;
    }
    else if (_start.y == 0) {
        return CMMSwipeDirectionTopDown;
    }
    else if (_start.y == 1) {
        return CMMSwipeDirectionBottomUp;
    }
    else if (_end.x == 0) {
        return CMMSwipeDirectionRightToLeft;
    }
    else if (_end.x == 1) {
        return CMMCSwipeDirectionLeftToRight;
    }
    else if (_end.y == 0) {
        return CMMSwipeDirectionBottomUp;
    }
    else if (_end.y == 1) {
        return CMMSwipeDirectionTopDown;
    }
    
    return CMMSwipeDirectionUnknown;
}

@end
