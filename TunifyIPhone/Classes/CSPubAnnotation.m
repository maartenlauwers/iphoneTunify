//
//  CSPubAnnotation.m
//  TunifyIPhone
//
//  Created by Elegia on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CSPubAnnotation.h"


@implementation CSPubAnnotation

@synthesize coordinate     = _coordinate;
@synthesize userData       = _userData;
@synthesize url            = _url;
@synthesize subtitle;
@synthesize pub;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate 
				   title:(NSString*)title
				   pub:(Pub*)pub
{
	self = [super init];
	_coordinate = coordinate;
	_title      = [title retain];
	self.pub	= pub;
	subtitle = nil;
	
	return self;
}

- (NSString *)title
{
	return _title;
}


- (NSString *)subtitle 
{
	return subtitle;
}

- (NSString *)subtitle:(NSString *)text
{
	
	subtitle = text;
	return subtitle;
}

-(void) dealloc
{
	[_title    release];
	[_userData release];
	[_url      release];
	[subtitle release];
	[pub release];
	[super dealloc];
}

@end