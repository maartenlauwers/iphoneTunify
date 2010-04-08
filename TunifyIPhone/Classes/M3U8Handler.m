//
//  M3U8Handler.m
//  TunifyIPhone
//
//  Created by Elegia on 27/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "M3U8Handler.h"


@implementation M3U8Handler

@synthesize playlist;
@synthesize delegate;

static M3U8Handler *sharedInstance = nil;

// Singleton methods

+ (M3U8Handler *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[M3U8Handler alloc] init];
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
    //do nothing
}

- (id)autorelease {
    return self;
}


- (void)parseUrl:(NSString *)url {
	
	if ([url hasSuffix:@".m3u8"] == FALSE) {
		NSLog(@"Invalid url");
		return 0;
	}
	NSString *data = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]];
	
	NSRange linkRange = [data rangeOfString:@"http://"];
	if (linkRange.location == NSNotFound) {
		NSLog(@"Invalid playlist");
		return 0;
	}
	
	NSLog(@"a");
	NSString *redirectUrl = [data substringFromIndex:linkRange.location];
	data = [NSString stringWithContentsOfURL:[NSURL URLWithString:redirectUrl]];
	NSLog(@"b");
	
	NSMutableArray *segments = [[NSMutableArray alloc] init];
	
	NSString *remainingSegments = data;
	NSRange segmentRange = [remainingSegments rangeOfString:@"#EXTINF:"];
	NSLog(@"c");	
	while(segmentRange.location != NSNotFound) {
		
		M3U8SegmentInfo *segment = [[M3U8SegmentInfo alloc] init];
		
		// Read the EXTINF number between #EXTINF: and the comma
		NSRange commaRange = [remainingSegments rangeOfString:@","];
		NSString *value = [remainingSegments substringWithRange:NSMakeRange(segmentRange.location + 8, commaRange.location - (segmentRange.location + 8))];
		segment.duration = [value intValue];
		
		// Read the segment link
		remainingSegments = [remainingSegments substringFromIndex:commaRange.location];
		NSRange rangeToSegmentStart = [remainingSegments rangeOfString:@"media"];
		NSRange rangeToSegmentEnd = [remainingSegments rangeOfString:@"#"];
		NSString *segmentLink = [remainingSegments substringWithRange:NSMakeRange(rangeToSegmentStart.location, rangeToSegmentEnd.location - rangeToSegmentStart.location)];
		segment.location = segmentLink;
		
		// Store the segment
		[segments addObject:segment];
		
		remainingSegments = [remainingSegments substringFromIndex:rangeToSegmentEnd.location];
		segmentRange = [remainingSegments rangeOfString:@"#EXTINF:"];
			NSLog(@"d");
	}
		NSLog(@"e");
	
	
	// Create a playlist with all the segments
	M3U8Playlist *playlist = [[M3U8Playlist alloc] initWithSegments:segments];
	self.playlist = playlist;

	
	
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(playlistAvailable:)]) {
		NSLog(@"playlist created");
		[delegate playlistAvailable:self];
	}   
	
	
/*
#EXTM3U
#EXT-X-TARGETDURATION:10
#EXT-X-MEDIA-SEQUENCE:1
#EXTINF:10,
	media_1.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_2.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_3.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_4.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_5.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_6.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_7.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_8.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_9.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_10.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_11.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_12.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_13.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_14.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_15.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_16.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_17.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_18.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_19.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_20.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_21.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_22.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_23.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_24.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_25.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_26.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_27.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_28.mp3?wowzasessionid=939457341
#EXTINF:10,
	media_29.mp3?wowzasessionid=939457341
#EXTINF:5,
	media_30.mp3?wowzasessionid=939457341
#EXT-X-ENDLIST
 */
	
}

- (void)dealloc {
	[delegate release];
	[playlist release];
	[super dealloc];
}

@end
