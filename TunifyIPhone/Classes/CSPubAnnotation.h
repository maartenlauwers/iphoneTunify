//
//  CSPubAnnotation.h
//  TunifyIPhone
//
//  Created by Elegia on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Pub.h"

@interface CSPubAnnotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D _coordinate;
	NSString*              _title;
	NSString*              _userData;
	NSURL*                 _url;
	NSString*				subtitle;
	Pub*					pub;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate 
				   title:(NSString*)title
				   pub:(Pub*)pub;

- (NSString *)subtitle:(NSString *)text;

@property (nonatomic, retain) NSString* userData;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic, retain) NSString* subtitle;
@property (nonatomic, retain) Pub* pub;

@end