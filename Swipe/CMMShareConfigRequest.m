//
//  CMMShareConfigRequest.m
//  CMMobile
//
//  Created by Victoria Teufel on 12.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import "CMMShareConfigRequest.h"

@implementation CMMShareConfigRequest

- (instancetype)initWithSettingsPlugin:(NSObject<CMMSettingsPlugin> *)settingsPlugin
                           httpRequest:(NSObject<CMMHttpRequestPlugin> *)httpRequest
                         entityGateway:(NSObject<CMMConfigurationEntityGatewayProtocol> *)entityGateway
{
    self = [super init];
    if (self) {
        _settingsPlugin = settingsPlugin;
        _httpRequest = httpRequest;
        _entityGateway = entityGateway;
    }
    return self;
}

- (void)sendShare:(NSObject<CMMConfigurationEntity> *)configuration toPartner:(NSString *)partnerId swipe:(CMMSwipe *)swipe
{
    NSString* jsonString = [_entityGateway confDocJsonForConfiguration:configuration];

    CMMHttpRequestPlugin_onComplete onComplete = ^(NSData* data) {
    };
    
    CMMHttpRequestPlugin_onError onError = ^(NSError* error) {
    };
    
    [_httpRequest startHTTPPost:[self _urlString:partnerId swipe:swipe]
                     postString:jsonString
                    contentType:@"application/json"
                completionBlock:onComplete
                     errorBlock:onError];
}


- (NSObject<CMMConfigurationEntity>*)getConfigurationFromConfDoc:(NSDictionary *)confDoc
{
    return [_entityGateway createConfigurationFromConfDocJson:confDoc];
}


#pragma mark -
#pragma mark Helper

- (NSString*)_urlString:(NSString*)pushToken swipe:(CMMSwipe*)swipe
{
    return [NSString stringWithFormat:@"%@share?deviceId=%@&sharePartnerId=%@&timestamp=%f&startX=%f&startY=%f&endX=%f&endY=%f",
            [self _serverUrl],
            [self _deviceToken],
            pushToken,
            swipe.timestamp,
            swipe.start.x,
            swipe.start.y,
            swipe.end.x,
            swipe.end.y];
}


- (NSString*)_serverUrl
{
    NSString* url = [_settingsPlugin stringValueForKey:@"CMMGestureUrlID"];
    if (url == nil) url = @"http://m-mobile.cas-merlin.de:9080/";
    return url;
}

- (NSString*)_deviceToken
{
    return [_settingsPlugin stringValueForKey:@"CMM_PUSH_DEVICE_TOKEN_KEY"];
}

@end
