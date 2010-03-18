//
//  CoordinatesTool.h
//  TunifyIPhone
//
//  Created by Elegia on 18/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoordinatesTool <NSObject>
@optional
- (void)userCoordinatesFound:(CoordinatesTool *)sender;
- (void)userCoordinatesError:(CoordinatesTool *)sender;
@end

@interface CoordinatesTool : NSObject <CLLocationManagerDelegate> {
	id<CoordinatesTool> delegate;
	
	CLLocationManager *locationManager;
	CLLocation *pubLocation;
	CLLocation *userLocation;
	
}

@property (assign) id<CoordinatesTool> delegate;
@property (nonatomic, retain) CLLocation *pubLocation;
@property (nonatomic, retain) CLLocation *userLocation;

- (void) fetchUserLocation;
- (CLLocation *) fetchPubLocation:(NSString *)pubAddress;
- (CLLocationDistance) fetchDistance;
- (CLLocationDistance) fetchDistance:(CLLocation *)locationA locationB:(CLLocation *)locationB;

@end
