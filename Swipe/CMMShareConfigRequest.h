//
//  CMMShareConfigRequest.h
//  CMMobile
//
//  Created by Victoria Teufel on 12.10.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMMSettingsPlugin.h"
#import "CMMHttpRequestPlugin.h"
#import "CMMConfigurationEntity.h"
#import "CMMConfigurationEntityGatewayProtocol.h"
#import "CMMSwipe.h"

@interface CMMShareConfigRequest : NSObject

{
    NSObject<CMMSettingsPlugin>* _settingsPlugin;
    NSObject<CMMHttpRequestPlugin>* _httpRequest;
    NSObject<CMMConfigurationEntityGatewayProtocol>* _entityGateway;
}

- (instancetype)initWithSettingsPlugin:(NSObject<CMMSettingsPlugin>*)settingsPlugin
                           httpRequest:(NSObject<CMMHttpRequestPlugin>*)httpRequest
                         entityGateway:(NSObject<CMMConfigurationEntityGatewayProtocol>*)entityGateway;

- (void)sendShare:(NSObject<CMMConfigurationEntity>*)configuration toPartner:(NSString*)partnerId swipe:(CMMSwipe*)swipe;
- (NSObject<CMMConfigurationEntity>*)getConfigurationFromConfDoc:(NSDictionary*)confDoc;

@end
