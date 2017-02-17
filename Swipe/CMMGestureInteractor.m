//
//  CMMGestureInteractor.m
//  CMMobile
//
//  Created by Victoria Teufel on 11.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import "CMMGestureInteractor.h"
#import "CMMApplication.h"

@implementation CMMGestureInteractor

- (instancetype)initWithSendWipeRequest:(CMMSendSwipeRequest *)swipeRequest
                           shareRequest:(CMMShareConfigRequest *)shareRequest
{
    self = [super init];
    if (self) {
        _swipeRequest = swipeRequest;
        _shareRequest = shareRequest;
        
        _state = CMMConnectionStateDisconnected;
        
        _delegates = [[NSMutableSet alloc] init];
        
        CMMApplication* app = (CMMApplication*)[CMMApplication sharedApplication];
        app.gestureDelegate = self;
    }
    return self;
}


#pragma mark -
#pragma mark Connection State

- (void)handleConnectionStateChange:(NSDictionary *)stateInformation
{
    NSString* state = stateInformation[@"state"];
    if ([state isEqualToString:@"connected"]) {
        _sharePartner = stateInformation[@"sharePartnerId"];
        _state = CMMConnectionStateConnected;
    }
    else if ([state isEqualToString:@"disconnected"]) {
        _sharePartner = nil;
        _state = CMMConnectionStateDisconnected;
    }
    else {
        return;
    }
    
    for (id<CMMGestureInteractorDelegate> delegate in _delegates) {
        [delegate connectionStateChanged:_state];
    }
}


#pragma mark -
#pragma mark Share

- (void)shareConfiguration:(NSObject<CMMConfigurationEntity> *)configuration
{
    if (_state == CMMConnectionStateDisconnected) return;
    
    [_shareRequest sendShare:configuration toPartner:_sharePartner swipe:_lastSwipe];
}

- (NSObject<CMMConfigurationEntity>*)getConfigurationFromConfDoc:(NSDictionary *)confDoc
{
    return [_shareRequest getConfigurationFromConfDoc:confDoc];
}

- (CMMSwipe*)getSwipeFromJson:(NSDictionary *)json
{
    CMMSwipe* swipe = [[CMMSwipe alloc] init];
    swipe.timestamp = ((NSNumber*)json[@"timestamp"]).doubleValue;
    NSDictionary* start = json[@"start"];
    swipe.start = CGPointMake(((NSNumber*)start[@"x"]).doubleValue, ((NSNumber*)start[@"y"]).doubleValue);
    NSDictionary* end = json[@"end"];
    swipe.end = CGPointMake(((NSNumber*)end[@"x"]).doubleValue, ((NSNumber*)end[@"y"]).doubleValue);
    return swipe;
}


#pragma mark -
#pragma mark Swipe Recognition

- (void)didRecognizeSwipe:(CMMSwipe *)swipe
{
    if (![self _swipeNeedsToBeSent:swipe]) return;
    _lastSwipe = swipe;
    [_swipeRequest sendSwipe:swipe];
}

- (BOOL)_swipeNeedsToBeSent:(CMMSwipe*)swipe
{
    if ([self _coordinateIsZero:swipe.start.x]) {
        swipe.start = CGPointMake(0, swipe.start.y);
        return YES;
    }
    if ([self _coordinateIsOne:swipe.start.x]) {
        swipe.start = CGPointMake(1, swipe.start.y);
        return YES;
    }
    if ([self _coordinateIsZero:swipe.start.y]) {
        swipe.start = CGPointMake(swipe.start.x, 0);
        return YES;
    }
    if ([self _coordinateIsOne:swipe.start.y]) {
        swipe.start = CGPointMake(swipe.start.x, 1);
        return YES;
    }
    if ([self _coordinateIsZero:swipe.end.x]) {
        swipe.end = CGPointMake(0, swipe.end.y);
        return YES;
    }
    if ([self _coordinateIsOne:swipe.end.x]) {
        swipe.end = CGPointMake(1, swipe.end.y);
        return YES;
    }
    if ([self _coordinateIsZero:swipe.end.y]) {
        swipe.end = CGPointMake(swipe.end.x, 0);
        return YES;
    }
    if ([self _coordinateIsOne:swipe.end.y]) {
        swipe.end = CGPointMake(swipe.end.x, 1);
        return YES;
    }
    return NO;
}

- (BOOL)_coordinateIsOne:(CGFloat)coordinate
{
    return (0.98 <= coordinate && coordinate <= 1);
}

- (BOOL)_coordinateIsZero:(CGFloat)coordinate
{
    return coordinate <= 0.02;
}


#pragma mark -
#pragma mark Delegates

- (void)registerAsDelegate:(id<CMMGestureInteractorDelegate>)delegate
{
    [_delegates addObject:delegate];
}

- (void)unregisterAsDelegate:(id<CMMGestureInteractorDelegate>)delegate
{
    [_delegates removeObject:delegate];
}

@end
