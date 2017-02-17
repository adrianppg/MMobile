//
//  CMMMultipeerConnectionManager.m
//  CMMobile
//
//  Created by Victoria Gärtner on 30.11.15.
//  Copyright © 2015 Florian Rieger. All rights reserved.
//

#import "CMMMultipeerConnectionManager.h"

#define CMM_SERVICE_TYPE @"cmm-config"

@implementation CMMMultipeerConnectionManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _connectivityMapping = [[NSMutableDictionary alloc] init];
        _peerIds = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setupPeerWithDisplayName:(NSString *)displayName
{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}


- (void)startBrowsingForNearbyPeers
{
    [self _advertiseSelf];
    [self _startDiscovering];
}

- (void)_advertiseSelf
{
    if (_advertiser == nil) {
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peerID discoveryInfo:nil serviceType:CMM_SERVICE_TYPE];
        _advertiser.delegate = self;
    }
    
    [_advertiser startAdvertisingPeer];
}


- (void)_startDiscovering
{
    if (_browser == nil) {
        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peerID serviceType:CMM_SERVICE_TYPE];
        _browser.delegate = self;
    }
    
    [_browser startBrowsingForPeers];
}



- (void)stopBrowsingForNearbyPeers
{
    [_browser stopBrowsingForPeers];
    [_advertiser stopAdvertisingPeer];
}


- (BOOL)isPeerReachable:(NSString *)peerId
{
    NSNumber* isReachableNumber = _connectivityMapping[peerId];
    return isReachableNumber.boolValue;
}


- (void)sendData:(NSData *)data toPeer:(NSString *)peerId error:(NSError *__autoreleasing *)error
{
    MCPeerID* peer = _peerIds[peerId];
    if (peer != nil) {
        [_session sendData:data toPeers:@[peer] withMode:MCSessionSendDataReliable error:error];
    }
    else {
        *error = [[NSError alloc] initWithDomain:@"CMMMobile" code:0 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"CMMNoSharePartnerKey", nil)}];
    }
}


#pragma mark -
#pragma mark MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info
{
    _peerIds[peerID.displayName] = peerID;
    [_browser invitePeer:peerID toSession:_session withContext:nil timeout:5.0];
}


- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
}



#pragma mark -
#pragma mark MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession * _Nonnull))invitationHandler
{
    invitationHandler(YES, _session);
}



#pragma mark -
#pragma mark MCSessionDelegate

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    BOOL isAvailable = NO;
    
    switch (state) {
        case MCSessionStateConnected:
            isAvailable = YES;  break;
            
        case MCSessionStateConnecting: break;
            
        case MCSessionStateNotConnected:
        default:
            isAvailable = NO; break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _connectivityMapping[peerID.displayName] = @(isAvailable);
        
        if (isAvailable) {
            [_delegate didFindPeerWithId:peerID.displayName];
        }
        else {
            [_delegate didLoosePeerWithId:peerID.displayName];
        }
    });
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_sessionDelegate didReceiveData:data];
    });
}


- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
}


- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
}


- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
}

@end
