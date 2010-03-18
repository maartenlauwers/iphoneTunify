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
@synthesize userLocation;
@synthesize pubLocation;

- (void) fetchUserLocation {
	
	locationManager = [[CLLocationManager alloc] init]; 
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; 
	locationManager.delegate = self; 
	[locationManager startUpdatingLocation]; 
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation { 
	self.userLocation = [[[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude] autorelease];
	
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(userCoordinatesFound:)]) {
		[delegate userCoordinatesFound:self];
	}   
} 

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error { 
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(userCoordinatesError:)]) {
		[delegate userCoordinatesFound:self];
	} 
} 

- (CLLocation *) fetchPubLocation:(NSString *)pubAddress {
	
	CLLocationDegrees pubLatitude;
	CLLocationDegrees pubLongitude;
	
	NSString *pubAddressString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv&sensor=false", [pubAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSString *pubAddressURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:pubAddressString]];
	NSArray *userLocationAddressResults = [pubAddressURL componentsSeparatedByString:@","];
	if([userLocationAddressResults count] >= 4 && [[userLocationAddressResults objectAtIndex:0] isEqualToString:@"200"]) {
		
		pubLatitude = [[userLocationAddressResults objectAtIndex:2] doubleValue];
		pubLongitude = [[userLocationAddressResults objectAtIndex:3] doubleValue];
	}
	else {
		//Error handling
		NSLog(@"Error while getting target address location");
	}
	
	self.pubLocation = [[[CLLocation alloc] initWithLatitude:pubLatitude longitude:pubLongitude] autorelease];
	return self.pubLocation;
}

- (CLLocationDistance) fetchDistance {
	return [self.userLocation getDistanceFrom:self.pubLocation];
}

- (CLLocationDistance) fetchDistance:(CLLocation *)locationA locationB:(CLLocation *)locationB {
	return [locationA getDistanceFrom:locationB];
}

@end
