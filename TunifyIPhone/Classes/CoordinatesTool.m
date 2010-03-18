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
	locationManager = [[CLLocationManager alloc] init]; 
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; 
	locationManager.delegate = self; 
	[locationManager startUpdatingLocation]; 
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation { 
		
	NSString *userLatitude = [[NSString alloc] initWithFormat:@"%f", newLocation.coordinate.latitude];
	NSString *userLongitude = [[NSString alloc] initWithFormat:@"%f", newLocation.coordinate.longitude];
	//self.userCoordinates = [NSString stringWithFormat:@"%@,%@", userLatitude, userLongitude];

	self.userCoordinates = [NSString stringWithFormat:@"%f,%f", 50.8610959, 2.7315335];
	
	CLLocationDegrees longitude = 2.7315335; //[userLongitude doubleValue];
	CLLocationDegrees latitude = 50.8610959; //[userLatitude doubleValue];
	
	NSLog(@"My Latitude: %f", latitude);
	NSLog(@"My Longitude: %f", longitude);
	CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
	self.userLocation = currentLocation; // [[[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude] autorelease];
	[currentLocation release];
	self.userLocationOK = TRUE;	
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(userLocationFound:)]) {
		[delegate userLocationFound:self];
	}   
} 

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error { 
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(userLocationError:)]) {
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
		if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(pubLocationError:)]) {
			[delegate pubLocationError:self];
		} 
	}
	
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(pubLocationFound:)]) {
		[delegate pubLocationFound:self];
	} 
}

- (CLLocationDistance) fetchDistance {
	return [self.userLocation getDistanceFrom:self.pubLocation];
}

- (CLLocationDistance) fetchDistance:(CLLocation *)locationA locationB:(CLLocation *)locationB {
	return [locationA getDistanceFrom:locationB];
}

@end
