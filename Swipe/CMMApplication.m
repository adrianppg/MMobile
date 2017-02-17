//
//  CMMApplication.m
//  CMMobile
//
//  Created by Victoria Teufel on 11.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import "CMMApplication.h"
#import "CMMAppDelegate.h"

@implementation CMMApplication

- (void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    
    if (event.type == UIEventTypeTouches) {
        NSSet <UITouch *>* touches = event.allTouches;
        for (UITouch* touch in touches) {
            if (touch.type == UITouchTypeDirect) {
                switch (touch.phase) {
                    case UITouchPhaseBegan:
                        [self _startNewSwipe:touch];
                        break;
                    case UITouchPhaseEnded:
                        [self _endSwipe:touch];
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

- (void)_startNewSwipe:(UITouch*)touch
{
    _currentSwipe = [[CMMSwipe alloc] init];
    _currentSwipe.start = [self _locationForTouch:touch];
}

- (void)_endSwipe:(UITouch*)touch
{
    _currentSwipe.end = [self _locationForTouch:touch];
    _currentSwipe.timestamp = [[NSDate date] timeIntervalSince1970];
    [_gestureDelegate didRecognizeSwipe:_currentSwipe];
}

- (CGPoint)_locationForTouch:(UITouch*)touch
{
    CMMAppDelegate* delegate = (CMMAppDelegate*)self.delegate;
    UIView* rootView = delegate.window.rootViewController.view;
    CGPoint absoulteLocation = [touch locationInView:rootView];
    return CGPointMake(absoulteLocation.x / rootView.bounds.size.width, absoulteLocation.y / rootView.bounds.size.height);
}

@end
