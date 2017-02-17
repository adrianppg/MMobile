//
//  CMMSwipe.h
//  CMMobile
//
//  Created by Victoria Teufel on 11.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CMMSwipeDirection) {
    CMMSwipeDirectionUnknown,
    CMMCSwipeDirectionLeftToRight,
    CMMSwipeDirectionRightToLeft,
    CMMSwipeDirectionBottomUp,
    CMMSwipeDirectionTopDown
};

@interface CMMSwipe : NSObject

@property(assign, nonatomic) NSTimeInterval timestamp;
@property(assign, nonatomic) CGPoint start;
@property(assign, nonatomic) CGPoint end;

@property(assign, nonatomic, readonly) CMMSwipeDirection swipeDirection;

@end
