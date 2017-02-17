//
//  CMMGestureInteractor.h
//  CMMobile
//
//  Created by Victoria Teufel on 11.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMMGestureRecognizerDelegate.h"
#import "CMMSendSwipeRequest.h"
#import "CMMConfigurationEntity.h"
#import "CMMShareConfigRequest.h"

typedef NS_ENUM(NSInteger, CMMConnectionState) {
    CMMConnectionStateConnected,
    CMMConnectionStateDisconnected
};

@protocol CMMGestureInteractorDelegate <NSObject>

- (void)connectionStateChanged:(CMMConnectionState)state;

@end

@interface CMMGestureInteractor : NSObject <CMMGestureRecognizerDelegate>
{
    CMMSendSwipeRequest* _swipeRequest;
    CMMShareConfigRequest* _shareRequest;
    NSString* _sharePartner;
    
    NSMutableSet* _delegates;
}

@property(assign, nonatomic, readonly) CMMConnectionState state;
@property(strong, nonatomic, readonly) CMMSwipe* lastSwipe;

- (instancetype)initWithSendWipeRequest:(CMMSendSwipeRequest*)swipeRequest
                           shareRequest:(CMMShareConfigRequest*)shareRequest;

- (void)handleConnectionStateChange:(NSDictionary*)stateInformation;
- (void)shareConfiguration:(NSObject<CMMConfigurationEntity>*)configuration;
- (NSObject<CMMConfigurationEntity>*)getConfigurationFromConfDoc:(NSDictionary*)confDoc;
- (CMMSwipe*)getSwipeFromJson:(NSDictionary*)json;

- (void)registerAsDelegate:(id<CMMGestureInteractorDelegate>)delegate;
- (void)unregisterAsDelegate:(id<CMMGestureInteractorDelegate>)delegate;

@end
