//
//  CMMSendSwipeRequest.h
//  CMMobile
//
//  Created by Victoria Teufel on 11.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMMSwipe.h"
#import "CMMSettingsPlugin.h"
#import "CMMHttpRequestPlugin.h"

@interface CMMSendSwipeRequest : NSObject
{
    NSObject<CMMSettingsPlugin>* _settingsPlugin;
    NSObject<CMMHttpRequestPlugin>* _httpRequest;
}

- (instancetype)initWithSettingsPlugin:(NSObject<CMMSettingsPlugin>*)settingsPlugin
                           httpRequest:(NSObject<CMMHttpRequestPlugin>*)httpRequest;

- (void)sendSwipe:(CMMSwipe*)swipe;

@end
