//
//  CMMBeaconPromoterEntityGateway.m
//  CMMobile
//
//  Created by Victoria Gärtner on 21.04.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import "CMMBeaconPromoterEntityGateway.h"

@implementation CMMBeaconPromoterEntityGateway


#pragma mark -
#pragma mark Initialization

- (instancetype)initWithBeaconPlugin:(NSObject<CMMBeaconPlugin> *)beaconPlugin
                         httpRequest:(NSObject<CMMHttpRequestPlugin> *)httpRequest
                      settingsPlugin:(NSObject<CMMSettingsPlugin> *)settingsPlugin
{
    self = [super init];
    if (self) {
        _beaconPlugin = beaconPlugin;
        _beaconPlugin.delegate = self;
        
        _httpRequest = httpRequest;
        _settingsPlugin = settingsPlugin;
    }
    return self;
}



#pragma mark -
#pragma mark Location

- (void)requestAuthorization
{
    [_beaconPlugin requestAuthorization:YES];
}


- (void)startMonitoringRegionWithIdentifier:(NSString *)identifier proximityUUID:(NSString *)proximityUUIDString major:(int)majorValue minor:(int)minorValue
{
    NSUUID* proximityUUId = [[NSUUID alloc] initWithUUIDString:proximityUUIDString];
    CLBeaconMajorValue major = (uint16_t) majorValue;
    CLBeaconMinorValue minor = (uint16_t) minorValue;
    
    CLBeaconRegion* region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUId major:major minor:minor identifier:identifier];
    
    [_beaconPlugin startMonitoringRegion:region];
}



#pragma mark -
#pragma mark CMMPromoterEntityGatewayDelegate

- (void)didFailMonitoring:(NSError *)error
{
    [_delegate didFailMonitoring:error];
}


- (void)didEnterRegion
{
    [_delegate didEnterRegion];
}


- (void)didExitRegion
{
    [_delegate didExitRegion];
}


#pragma mark -
#pragma mark Promoter Visits

- (void)recordPromoterVisitForDeviceToken:(NSString *)deviceToken
{
    if (deviceToken == nil) {
        return;
    }
    
    NSString* url = [self _urlForDeviceToken:deviceToken path:@"recordPromoterVisit"];
    [_httpRequest startHTTPGet:url completionBlock:nil errorBlock:nil];
}


- (void)removePromoterVisitForDeviceToken:(NSString *)deviceToken
{
    if (deviceToken == nil) {
        return;
    }
    
    NSString* url = [self _urlForDeviceToken:deviceToken path:@"removePromoterVisit"];
    [_httpRequest startHTTPGet:url completionBlock:nil errorBlock:nil];
}


- (NSString*)_urlForDeviceToken:(NSString*)deviceToken path:(NSString*)path
{
    NSString* baseUrl = [self _baseUrlFromSettings];
    return [NSString stringWithFormat:@"%@%@?devicetoken=%@&pass=0fb8df330fce1ba3fd099bf4f39b7aa5", baseUrl, path, deviceToken];
}


- (NSString*)_baseUrlFromSettings
{
    NSString* url = [_settingsPlugin stringValueForKey:@"CMMPromoterUrlID"];
    if (url == nil) {
        url = @"http://sysplace.ameria.de/";
    }
    
    return url;
}

@end
