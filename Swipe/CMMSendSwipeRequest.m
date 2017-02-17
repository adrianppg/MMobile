//
//  CMMSendSwipeRequest.m
//  CMMobile
//
//  Created by Victoria Teufel on 11.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import "CMMSendSwipeRequest.h"

@implementation CMMSendSwipeRequest

- (instancetype)initWithSettingsPlugin:(NSObject<CMMSettingsPlugin>*)settingsPlugin
                           httpRequest:(NSObject<CMMHttpRequestPlugin> *)httpRequest
{
    self = [super init];
    if (self) {
        _settingsPlugin = settingsPlugin;
        _httpRequest = httpRequest;
    }
    return self;
}

- (void)sendSwipe:(CMMSwipe*)swipe
{
    NSString* url = [NSString stringWithFormat:@"%@gesture?deviceId=%@&timestamp=%f&startX=%f&startY=%f&endX=%f&endY=%f",
                     [self _serverUrl],
                     [self _deviceToken],
                     swipe.timestamp,
                     swipe.start.x,
                     swipe.start.y,
                     swipe.end.x,
                     swipe.end.y];
    
    [_httpRequest startHTTPGet:url completionBlock:^(NSData *data) {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } errorBlock:nil];
}

- (NSString*)_deviceToken
{
    return [_settingsPlugin stringValueForKey:@"CMM_PUSH_DEVICE_TOKEN_KEY"];
}

- (NSString*)_serverUrl
{
    NSString* url = [_settingsPlugin stringValueForKey:@"CMMGestureUrlID"];
    if (url == nil) url = @"http://m-mobile.cas-merlin.de:9080/";
    return url;
}

@end
