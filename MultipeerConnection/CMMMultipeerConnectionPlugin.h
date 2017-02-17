//
//  CMMMultipeerConnectionPlugin.h
//  CMMobile
//
//  Created by Victoria Gärtner on 30.11.15.
//  Copyright © 2015 Florian Rieger. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMMMultipeerDiscoryDelegate <NSObject>
- (void)didFindPeerWithId:(NSString*)peerId;
- (void)didLoosePeerWithId:(NSString*)peerId;
@end

@protocol CMMMultipeerSessionDelegate <NSObject>
- (void)didReceiveData:(NSData*)data;
@end

@protocol CMMMultipeerConnectionPlugin <NSObject>

@property (weak, nonatomic) id<CMMMultipeerDiscoryDelegate> delegate;
@property (weak, nonatomic) id<CMMMultipeerSessionDelegate> sessionDelegate;

- (void)setupPeerWithDisplayName:(NSString*)displayName;
- (void)startBrowsingForNearbyPeers;
- (void)stopBrowsingForNearbyPeers;
- (BOOL)isPeerReachable:(NSString*)peerId;
- (void)sendData:(NSData*)data toPeer:(NSString*)peerId error:(NSError**)error;

@end
