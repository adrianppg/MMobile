//
//  CMMBeaconManager.h
//  CMMobile
//
//  Created by Victoria Gärtner on 20.04.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CMMBeaconPlugin.h"

@interface CMMBeaconManager : NSObject <CMMBeaconPlugin, CLLocationManagerDelegate>
{
    CLLocationManager* _locationManager;
    CLBeaconRegion* _region;
    
    BOOL _foundBeacon;
}

@property (strong, nonatomic, readonly) CLLocationManager* locationManager;
@property (weak, nonatomic) id<CMMBeaconPluginDelegate> delegate;


- (instancetype)initWithLocationManager:(CLLocationManager*)locationManager;

@end
