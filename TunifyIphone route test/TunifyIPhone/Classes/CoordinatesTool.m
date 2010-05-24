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
@synthesize lastIndex;
@synthesize inMapView;

// route testing
@synthesize coords;

static CoordinatesTool *sharedInstance = nil;

// Singleton methods

+ (CoordinatesTool *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[CoordinatesTool alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
	NSLog(@"Releasing coordinatestool. THIS SHOULDN'T HAPPEN!");
	[userLocation release];
	[pubLocation release];
	[userCoordinates release];
	[pubCoordinates release];
	[delegate release];
}

- (id)autorelease {
    return self;
}

- (void) reInit {
	locationManager = [[CLLocationManager alloc] init];
	[self stop];
	self.userLocationOK = nil;
	self.pubLocationOK = nil;
	
	// Route test
	NSLog(@"COORDINATESTOOL REINIT EXECUTED");
	coords = [[NSMutableArray alloc] init];
	
	CLLocation *currentLocation = nil;
	
	// Tervuursesteenweg 433, 3001 Heverlee
	CLLocationDegrees longitude = 4.6644344; //[userLongitude doubleValue]; // Lat and long op basis van tervuursesteenweg 433
	CLLocationDegrees latitude = 50.8728119; //[userLatitude doubleValue];
	currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	[coords addObject:currentLocation];
	
	// Tervuursesteenweg 300, 3001 Heverlee
	longitude = 4.66181; //[userLongitude doubleValue]; // Lat and long op basis van tervuursesteenweg 433
	latitude = 50.87212; //[userLatitude doubleValue];
	currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	[coords addObject:currentLocation];
	
	// Celestijnenlaan 20, 3001 Heverlee
	longitude = 4.67347; //[userLongitude doubleValue]; // Lat and long op basis van tervuursesteenweg 433
	latitude = 50.87247; //[userLatitude doubleValue];
	currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	[coords addObject:currentLocation];
	
	// Celestijnenlaan 100, 3001 Heverlee
	longitude = 4.67848; //[userLongitude doubleValue]; // Lat and long op basis van tervuursesteenweg 433
	latitude = 50.86772; //[userLatitude doubleValue];
	currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	[coords addObject:currentLocation];
	
	// Celestijnenlaan 200, 3001 Heverlee
	longitude = 4.67857; //8 //[userLongitude doubleValue]; // Lat and long op basis van tervuursesteenweg 433
	latitude = 50.86312; //1 //[userLatitude doubleValue];
	currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	[coords addObject:currentLocation];
	
	
}

- (void) fetchUserLocation {
	NSLog(@"fetchUserLocation");
	//locationManager = [[CLLocationManager alloc] init]; 
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; 
	locationManager.delegate = self; 
	[locationManager startUpdatingLocation]; 
	NSLog(@"end fetchUserLocation");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation { 
	NSLog(@"didUpdateToLocation");
	NSString *userLatitude = [[NSString alloc] initWithFormat:@"%f", newLocation.coordinate.latitude];
	NSString *userLongitude = [[NSString alloc] initWithFormat:@"%f", newLocation.coordinate.longitude];

	self.userCoordinates = [NSString stringWithFormat:@"%@,%@", userLatitude, userLongitude];
	CLLocationDegrees longitude = [userLongitude doubleValue];
	CLLocationDegrees latitude = [userLatitude doubleValue];
	
	// Uncomment the following when working on the iPhone simulator
	self.userCoordinates = [NSString stringWithFormat:@"%f,%f", 50.8728119, 4.6644344];
	longitude = 4.6644344; //[userLongitude doubleValue]; // Lat and long op basis van tervuursesteenweg 433
	latitude = 50.8728119; //[userLatitude doubleValue];

	//CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	//NSLog(@"%f", newLocation.coordinate.latitude);
	//NSLog(@"%f", newLocation.coordinate.longitude);
	
	// ENABLE THE LINE BENEATH FOR ACTUAL IPHONE
	//CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
	
	// DISABLE THE LINE BENEATH FOR ACTUAL IPHONE
	CLLocation* currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	
	if(self.inMapView) {
		NSLog(@"last index: %d", self.lastIndex);
		CLLocation *newLocation = [self.coords objectAtIndex:self.lastIndex];
		self.userLocation = newLocation;
		self.userCoordinates = [NSString stringWithFormat:@"%f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
		if (lastIndex < [coords count] - 1) {
			self.lastIndex += 1;
		}

	} else {
		self.userLocation = [currentLocation copy]; // [[[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude] autorelease];
	}
	
	[currentLocation release];
	self.userLocationOK = TRUE;	
	[locationManager stopUpdatingLocation];
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(userLocationFound:)]) {
		[delegate userLocationFound:self];
	}   
} 

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error { 
	self.userLocationOK = FALSE;
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(userLocationError:)]) {
		[delegate userLocationError:self];
	} 
} 

- (void) fetchPubLocation:(Pub *)pub {
	NSString *pubAddress = [NSString stringWithFormat:@"%@ %@, %@ %@", [pub street], [pub number], [pub zipcode], [pub city]];
	NSString *pubLatitude;
	NSString *pubLongitude;
	NSLog(@"PubAddress below");
	NSLog(@"PubAddress: %@", pubAddress);
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
		self.pubLocationOK = TRUE;
	}
	else {
		//Error handling
		// Probably can't connect to google maps, so fetch the location from the Core Date pub object (which is the most realistic way)
		
		CLLocationDegrees longitude = [pub.longitude doubleValue];
		CLLocationDegrees latitude = [pub.latitude doubleValue];
		CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
		
		NSLog(@"pub longitude: %f", longitude);
		NSLog(@"pub latitude: %f", latitude);
		self.pubLocation = currentLocation;
		self.pubCoordinates = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
		self.pubLocationOK = TRUE;
		
		if (currentLocation == nil) {
			self.pubLocationOK = FALSE;
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pubLocationError:)]) {
				[delegate pubLocationError:self];
			} 
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
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; 
	locationManager.delegate = self; 
	locationManager.headingFilter = 2;
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
	self.userLocationOK = FALSE;
	self.pubLocationOK = FALSE;
}

@end
