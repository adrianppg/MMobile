//
//  CMMBeaconPlugin.h
//  CMMobile
//
//  Created by Victoria Gärtner on 20.04.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CMMBeaconPluginDelegate <NSObject>

- (void)didEnterRegion;
- (void)didExitRegion;
- (void)didFailMonitoring:(NSError*)error;

@end


@protocol CMMBeaconPlugin <NSObject>

@property (weak, nonatomic) id<CMMBeaconPluginDelegate> delegate;

- (void)requestAuthorization:(BOOL)always;

- (void)startMonitoringRegion:(CLBeaconRegion*)region;
- (void)stopMonitoringRegion;

@end



