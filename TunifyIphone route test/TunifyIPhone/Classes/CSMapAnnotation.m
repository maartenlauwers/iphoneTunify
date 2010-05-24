//
//  CSMapAnnotation.m
//  mapLines
//
//  Created by Craig on 5/15/09.
//  Copyright 2009 Craig Spitzkoff. All rights reserved.
//

#import "CSMapAnnotation.h"


@implementation CSMapAnnotation

@synthesize coordinate     = _coordinate;
@synthesize annotationType = _annotationType;
@synthesize userData       = _userData;
@synthesize url            = _url;
@synthesize subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate 
		  annotationType:(CSMapAnnotationType) annotationType
				   title:(NSString*)title
{
	self = [super init];
	_coordinate = coordinate;
	_title      = [title retain];
	_annotationType = annotationType;
	
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
	NSLog(text);
	if(_annotationType == CSMapAnnotationTypeStart || 
	   _annotationType == CSMapAnnotationTypeEnd ||
	   _annotationType == CSMapAnnotationTypePub)
	{
		subtitle = text;
	}
	
	return subtitle;
}




-(void) dealloc
{
	[_title    release];
	[_userData release];
	[_url      release];
	[subtitle release];
	
	[super dealloc];
}

@end
