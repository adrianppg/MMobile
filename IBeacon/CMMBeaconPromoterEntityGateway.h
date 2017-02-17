//
//  CMMBeaconPromoterEntityGateway.h
//  CMMobile
//
//  Created by Victoria Gärtner on 21.04.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMMPromoterEntityGateway.h"
#import "CMMBeaconPlugin.h"
#import "CMMHttpRequestPlugin.h"
#import "CMMSettingsPlugin.h"

@interface CMMBeaconPromoterEntityGateway : NSObject <CMMPromoterEntityGateway, CMMBeaconPluginDelegate>
{
    NSObject<CMMBeaconPlugin>* _beaconPlugin;
    NSObject<CMMHttpRequestPlugin>* _httpRequest;
    NSObject<CMMSettingsPlugin>* _settingsPlugin;
}

@property (strong, nonatomic, readonly) NSObject<CMMBeaconPlugin>* beaconPlugin;
@property (strong, nonatomic, readonly) NSObject<CMMHttpRequestPlugin>* httpRequest;
@property (strong, nonatomic, readonly) NSObject<CMMSettingsPlugin>* settingsPlugin;
@property (weak, nonatomic) id<CMMPromoterEntityGatewayDelegate> delegate;

- (instancetype)initWithBeaconPlugin:(NSObject<CMMBeaconPlugin>*)beaconPlugin
                         httpRequest:(NSObject<CMMHttpRequestPlugin>*)httpRequest
                      settingsPlugin:(NSObject<CMMSettingsPlugin>*)settingsPlugin;

@end
