//
//  CoordinatesTool.m
//  TunifyIPhone
//
//  Created by Elegia on 18/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CoordinatesTool.h"
@implementation CoordinatesTool
@synthesize delegate;
@synthesize userCoordinates;
@synthesize userLocation;
@synthesize pubCoordinates;
@synthesize pubLocation;
//@synthesize heading;
@synthesize userLocationOK;
@synthesize pubLocationOK;


- (id)init
{
    if ((self = [super init])) {
		self.userLocationOK = FALSE;
		self.pubLocationOK = FALSE;
    }
    return self;
}
- (void) fetchUserLocation {
	NSLog(@"fetchUserLocation");
	locationManager = [[CLLocationManager alloc] init]; 
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; 
	locationManager.delegate = self; 
	[locationManager startUpdatingLocation]; 
	NSLog(@"end fetchUserLocation");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation { 
	NSLog(@"didUpdateToLocation");
	NSString *userLatitude = [[NSString alloc] initWithFormat:@"%f", newLocation.coordinate.latitude];
	NSString *userLongitude = [[NSString alloc] initWithFormat:@"%f", newLocation.coordinate.longitude];

	//self.userCoordinates = [NSString stringWithFormat:@"%f,%f", 50.8728119, 4.6644344];
	self.userCoordinates = [NSString stringWithFormat:@"%@,%@", userLatitude, userLongitude];
	//CLLocationDegrees longitude = 4.6644344; //[userLongitude doubleValue]; // Lat and long op basis van tervuursesteenweg 433
	//CLLocationDegrees latitude = 50.8728119; //[userLatitude doubleValue];
	CLLocationDegrees longitude = [userLongitude doubleValue];
	CLLocationDegrees latitude = [userLatitude doubleValue];

	CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
	self.userLocation = currentLocation; // [[[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude] autorelease];
	//[currentLocation release];
	self.userLocationOK = TRUE;	
	[locationManager stopUpdatingLocation];
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(userLocationFound:)]) {
		[delegate userLocationFound:self];
	}   
} 

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error { 
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(userLocationError:)]) {
		[delegate userLocationError:self];
	} 
} 

- (void) fetchPubLocation:(NSString *)pubAddress {
	NSString *pubLatitude;
	NSString *pubLongitude;
	
	NSString *pubAddressString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv&sensor=false", [pubAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSString *pubAddressURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:pubAddressString]];
	NSArray *pubLocationAddressResults = [pubAddressURL componentsSeparatedByString:@","];
	if([pubLocationAddressResults count] >= 4 && [[pubLocationAddressResults objectAtIndex:0] isEqualToString:@"200"]) {
		
		pubLatitude = [pubLocationAddressResults objectAtIndex:2];
		pubLongitude = [pubLocationAddressResults objectAtIndex:3];
		
		self.pubCoordinates = [NSString stringWithFormat:@"%@,%@", pubLatitude, pubLongitude];
		
		CLLocationDegrees longitude = [pubLongitude doubleValue];
		CLLocationDegrees latitude = [pubLatitude doubleValue];
		CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
		
		self.pubLocation = currentLocation;
		[currentLocation release];
		
		self.pubLocationOK = TRUE;
	}
	else {
		//Error handling
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pubLocationError:)]) {
			[delegate pubLocationError:self];
		} 
	}
	
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pubLocationFound:)]) {
		[delegate pubLocationFound:self];
	} 
}

- (CLLocationDistance) fetchDistance {
	return [self.userLocation getDistanceFrom:self.pubLocation];
}

- (CLLocationDistance) fetchDistance:(CLLocation *)locationA locationB:(CLLocation *)locationB {
	return [locationA getDistanceFrom:locationB];
}

- (void)fetchHeading {
	locationManager = [[CLLocationManager alloc] init]; 
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; 
	locationManager.delegate = self; 
	locationManager.headingFilter = 1;
	[locationManager startUpdatingHeading]; 
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	
	heading = [[NSString stringWithFormat:@"%.0f", [newHeading trueHeading]] floatValue];
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(headingUpdated:)]) {
		[delegate headingUpdated:self];
	} 
}

- (float)getHeading {
	return heading;
}

- (void) stop {
	self.delegate = nil;
	[locationManager stopUpdatingLocation];
	[locationManager stopUpdatingHeading];
}

@end
