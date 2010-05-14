//
//  M3U8Playlist.m
//  TunifyIPhone
//
//  Created by Elegia on 27/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "M3U8Playlist.h"


@implementation M3U8Playlist

@synthesize segments;
@synthesize length;

- (id)initWithSegments:(NSMutableArray *)segmentList
{
	if ((self = [super init])) {
		self.segments = segmentList;
		self.length = [self.segments count];
    }
	
	return self;	
}

- (M3U8SegmentInfo *)getSegment:(NSInteger)index {
	M3U8SegmentInfo *info = [self.segments objectAtIndex:index];
	NSLog(@"location: %@", info.location);
	return info;
}

- (void)dealloc {
	
	[segments release];
	[super dealloc];
}
@end
