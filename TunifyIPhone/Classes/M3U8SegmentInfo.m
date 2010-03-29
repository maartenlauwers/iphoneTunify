//
//  M3U8SegmentInfo.m
//  TunifyIPhone
//
//  Created by Elegia on 27/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "M3U8SegmentInfo.h"


@implementation M3U8SegmentInfo

@synthesize duration;
@synthesize location;

- (void)dealloc {
	[location release];
	[super dealloc];
}
@end
