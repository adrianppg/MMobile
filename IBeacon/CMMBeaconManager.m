//
//  CMMBeaconManager.m
//  CMMobile
//
//  Created by Victoria Gärtner on 20.04.16.
//  Copyright © 2016 Florian Rieger. All rights reserved.
//

#import "CMMBeaconManager.h"

@implementation CMMBeaconManager

- (instancetype)initWithLocationManager:(CLLocationManager *)locationManager
{
    self = [super init];
    if (self) {
        _locationManager = locationManager;
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        _foundBeacon = NO;
    }
    return self;
}



- (void)requestAuthorization:(BOOL)always
{
    if (always) {
        [_locationManager requestAlwaysAuthorization];
    }
    else {
        [_locationManager requestWhenInUseAuthorization];
    }
}


- (void)startMonitoringRegion:(CLBeaconRegion*)region
{
    _region = region;
    
    [_locationManager requestStateForRegion:_region];
    
    [_locationManager startMonitoringForRegion:_region];
    [_locationManager startRangingBeaconsInRegion:_region];
}


- (void)stopMonitoringRegion
{
    [_locationManager stopMonitoringForRegion:_region];
    [_locationManager stopRangingBeaconsInRegion:_region];
}



#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    [_delegate didFailMonitoring:error];
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    [_delegate didFailMonitoring:error];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region.identifier isEqualToString:_region.identifier]) {
        if (!_foundBeacon) {
            [_delegate didEnterRegion];
        }
        _foundBeacon = YES;
    }
}


- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region.identifier isEqualToString:_region.identifier]) {
        if (_foundBeacon) {
            [_delegate didExitRegion];
        }
        _foundBeacon = NO;
    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(nonnull CLRegion *)region
{
    if (! [region.identifier isEqualToString:_region.identifier]) {
        return;
    }
    
    if (state == CLRegionStateInside) {
        if (!_foundBeacon) {
            [_delegate didEnterRegion];
            _foundBeacon = YES;
        }
    }
    else {
        if (_foundBeacon) {
            [_delegate didExitRegion];
            _foundBeacon = NO;
        }
    }
}

@end
