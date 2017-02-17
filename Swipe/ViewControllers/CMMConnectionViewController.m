//
//  CMMConnectionViewController.m
//  CMMobile
//
//  Created by Victoria Teufel on 20.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import "CMMConnectionViewController.h"
#import "CMMSwipe.h"
#import "CMMLogic.h"

@implementation CMMConnectionViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self _addImageViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self _arrangeImageView];
}

- (void)_addImageViews
{
    _plugImageView = [self _imageViewForImage:@"plug"];
    _pinsImageView = [self _imageViewForImage:@"plug_pins"];
    
    _socketImageView = [self _imageViewForImage:@"socket"];
}

- (UIImageView*)_imageViewForImage:(NSString*)image
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    [imageView sizeToFit];
    imageView.hidden = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    return imageView;
}

- (void)_arrangeImageView
{
    CMMSwipe* swipe = [CMMLogic sharedInstance].gestureInteractor.lastSwipe;
    if (swipe == nil) return;
    
    CMMSwipeDirection direction = swipe.swipeDirection;
    if (direction == CMMSwipeDirectionUnknown) return;
    
    switch (direction) {
        case CMMSwipeDirectionTopDown:
            [self _showSocket:direction];
            break;
        case CMMSwipeDirectionBottomUp:
            [self _showPlugAndPins:direction];
            break;
        case CMMCSwipeDirectionLeftToRight:
            [self _showPlugAndPins:direction];
            break;
        case CMMSwipeDirectionRightToLeft:
            [self _showSocket:direction];
            break;
        default:
            break;
    }
}

- (void)_showSocket:(CMMSwipeDirection)direction
{
    if (direction == CMMSwipeDirectionUnknown || direction == CMMCSwipeDirectionLeftToRight || direction == CMMSwipeDirectionBottomUp) return;
    
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGFloat height = _socketImageView.frame.size.height;
    CGFloat width = _socketImageView.frame.size.width;
    CGFloat pinsHeight = _pinsImageView.frame.size.height;
    CGFloat pinsWidth = _pinsImageView.frame.size.width;
    
    if (direction == CMMSwipeDirectionTopDown) {
        _socketImageView.transform = CGAffineTransformMakeRotation(M_PI + M_PI/2);
        _socketImageView.frame = CGRectMake((windowSize.width - height)/2, -height, height, width);
        _pinsImageView.transform = CGAffineTransformMakeRotation(M_PI + M_PI/2);
        _pinsImageView.frame = CGRectMake((windowSize.width - pinsHeight)/2, windowSize.height, pinsHeight, pinsWidth);
    }
    else if (direction == CMMSwipeDirectionRightToLeft) {
        _socketImageView.frame = CGRectMake(width + windowSize.width, (windowSize.height - height)/2, width, height);
        _pinsImageView.frame = CGRectMake(- pinsWidth, (windowSize.height - pinsHeight)/2, pinsWidth, pinsHeight);
    }
    
    _socketImageView.hidden = NO;
    _pinsImageView.hidden = NO;
    
    [self _animateSocket];
}

- (void)_animateSocket
{
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGPoint center = _socketImageView.center;
    
    [UIView animateWithDuration:START_ANIMATION_DURATION animations:^{
        CGRect frame = _socketImageView.frame;
        
        if (center.x == windowSize.width / 2) {
            frame.origin.y = -frame.size.height * 0.55f;
        }
        else if (center.y == windowSize.height / 2) {
            frame.origin.x = windowSize.width - frame.size.width * 0.45f;
        }
        
        _socketImageView.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:END_ANIMATION_DURATION delay:ANIMATION_PAUSE_DURATION options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect frame = _socketImageView.frame;
            if (center.x == windowSize.width / 2) {
                frame.origin.y = windowSize.height - frame.size.height;
            }
            else if (center.y == windowSize.height / 2) {
                frame.origin.x = 0;
            }
            
            _socketImageView.frame = frame;
        } completion:^(BOOL finished2) {
            [self _dismiss];
        }];
        
        double duration = END_ANIMATION_DURATION / 2;
        double delay = ANIMATION_PAUSE_DURATION + duration;
        if (center.y == windowSize.height / 2) {
            delay = ANIMATION_PAUSE_DURATION + (END_ANIMATION_DURATION * 2/3);
        }
        
        [UIView animateWithDuration:duration delay:delay  options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect pinsFrame = _pinsImageView.frame;
            
            if (center.x == windowSize.width / 2) {
                pinsFrame.origin.y = windowSize.height - pinsFrame.size.height;
            }
            else if (center.y == windowSize.height / 2) {
                pinsFrame.origin.x = 0;
            }
    
            _pinsImageView.frame = pinsFrame;
        } completion:nil];
    }];
}

- (void)_showPlugAndPins:(CMMSwipeDirection)direction
{
    if (direction == CMMSwipeDirectionUnknown || direction == CMMSwipeDirectionRightToLeft || direction == CMMSwipeDirectionTopDown) return;
    
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGFloat pinsHeight = _pinsImageView.frame.size.height;
    CGFloat pinsWidth = _pinsImageView.frame.size.width;
    CGFloat plugHeight = _plugImageView.frame.size.height;
    CGFloat plugWidth = _plugImageView.frame.size.width;
    
    if (direction == CMMSwipeDirectionBottomUp) {
        _pinsImageView.transform = CGAffineTransformMakeRotation(M_PI + M_PI/2);
        _pinsImageView.frame = CGRectMake((windowSize.width - pinsHeight)/2, windowSize.height, pinsHeight, pinsWidth);
        
        _plugImageView.transform = CGAffineTransformMakeRotation(M_PI + M_PI/2);
        _plugImageView.frame = CGRectMake((windowSize.width - plugHeight)/2, windowSize.height + pinsWidth, plugHeight, plugWidth);
        
    }
    else if (direction == CMMCSwipeDirectionLeftToRight) {
        _pinsImageView.frame = CGRectMake(-pinsWidth, (windowSize.height - pinsHeight)/2, pinsWidth, pinsHeight);
        _plugImageView.frame = CGRectMake(- (pinsWidth + plugWidth), (windowSize.height - pinsHeight)/2, plugWidth, plugHeight);
    }
    
    _pinsImageView.hidden = NO;
    _plugImageView.hidden = NO;
    
    [self _animatePinsAndPlug];
}

- (void)_animatePinsAndPlug
{
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGPoint center = _pinsImageView.center;
    
    [UIView animateWithDuration:START_ANIMATION_DURATION animations:^{
        CGRect pinFrame = _pinsImageView.frame;
        CGRect plugFrame = _plugImageView.frame;
        
        if (center.x == windowSize.width / 2) {
            plugFrame.origin.y = windowSize.height - plugFrame.size.height*0.45f;
            pinFrame.origin.y = plugFrame.origin.y - pinFrame.size.height;
        }
        else if (center.y == windowSize.height / 2) {
            plugFrame.origin.x = (plugFrame.size.width*0.45f - windowSize.width);
            pinFrame.origin.x = windowSize.width - plugFrame.size.width * 0.45f;
        }
        
        _pinsImageView.frame = pinFrame;
        _plugImageView.frame = plugFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:END_ANIMATION_DURATION delay:ANIMATION_PAUSE_DURATION options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGRect pinFrame = _pinsImageView.frame;
            CGRect plugFrame = _plugImageView.frame;
            
            if (center.x == windowSize.width / 2) {
                pinFrame.origin.y = - pinFrame.size.height;
                plugFrame.origin.y = 0;
            }
            else if (center.y == windowSize.height / 2) {
                pinFrame.origin.x = windowSize.width;
                plugFrame.origin.x = windowSize.width - plugFrame.size.width;
            }
            
            _pinsImageView.frame = pinFrame;
            _plugImageView.frame = plugFrame;
        } completion:^(BOOL finished2) {
            [self _dismiss];
        }];
    }];
}

- (void)_dismiss
{
    [UIView animateWithDuration:START_ANIMATION_DURATION delay:DISMISS_ANIMATION_DURATION options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    }  completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

@end
