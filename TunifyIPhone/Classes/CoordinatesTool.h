//
//  CoordinatesTool.h
//  TunifyIPhone
//
//  Created by Elegia on 18/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Pub.h"

@class CoordinatesTool;
@protocol CoordinatesToolDelegate <NSObject>
@optional
- (void) userLocationFound:(CoordinatesTool *)sender;
- (void) userLocationError:(CoordinatesTool *)sender;
- (void) pubLocationFound:(CoordinatesTool *)sender;
- (void) pubLocationError:(CoordinatesTool *)sender;
- (void) headingUpdated:(CoordinatesTool *)sender;
@end

@interface CoordinatesTool : NSObject <CLLocationManagerDelegate> {
	id <CoordinatesToolDelegate> delegate;
	
	CLLocationManager *locationManager;
	NSString *pubCoordinates;
	CLLocation *pubLocation;
	NSString *userCoordinates;
	CLLocation *userLocation;
	float heading;
	BOOL pubLocationOK;
	BOOL userLocationOK;
	
	// Route testing
	//NSMutableArray *coords;
	//NSInteger lastIndex;
	//BOOL inMapView;
	
}

@property (nonatomic, assign) id <CoordinatesToolDelegate> delegate;
@property (nonatomic, retain) NSString *pubCoordinates;
@property (nonatomic, retain) CLLocation *pubLocation;
@property (nonatomic, retain) NSString *userCoordinates;
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, assign) BOOL pubLocationOK;
@property (nonatomic, assign) BOOL userLocationOK;
//@property (nonatomic, assign) NSMutableArray *coords;
//@property (assign) NSInteger lastIndex;
//@property (assign) BOOL inMapView;

+ (CoordinatesTool *)sharedInstance;
- (void)reInit;
- (void) stop;
- (void) fetchUserLocation;
- (void) fetchPubLocation:(Pub *)pub;
- (void) fetchHeading;
- (CLLocationDistance) fetchDistance;
- (CLLocationDistance) fetchDistance:(CLLocation *)locationA locationB:(CLLocation *)locationB;
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading;
- (float)getHeading;
@end