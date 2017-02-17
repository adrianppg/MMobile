//
//  CMMMultipeerConnectionManager.h
//  CMMobile
//
//  Created by Victoria Gärtner on 30.11.15.
//  Copyright © 2015 Florian Rieger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMMMultipeerConnectionPlugin.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface CMMMultipeerConnectionManager : NSObject <CMMMultipeerConnectionPlugin, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>
{
    MCPeerID* _peerID;
    MCSession* _session;
    MCNearbyServiceBrowser* _browser;
    MCNearbyServiceAdvertiser* _advertiser;
    
    NSMutableDictionary* _connectivityMapping;
    NSMutableDictionary* _peerIds;
}

@property (weak, nonatomic) id<CMMMultipeerDiscoryDelegate> delegate;
@property (weak, nonatomic) id<CMMMultipeerSessionDelegate> sessionDelegate;

@end
