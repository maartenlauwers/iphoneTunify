//
//  AudioPlayer.m
//  TunifyIPhone
//
//  Created by Elegia on 27/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>

@implementation AudioPlayer

@synthesize streamer;

- (void)play:(NSString *)path 
{
	[self createStreamer:path];
	[streamer start];
}

- (void)stop {
	[self destroyStreamer];
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer:(NSString*)path
{
	if (streamer)
	{
		return;
	}
	
	[self destroyStreamer];
	
	NSString *escapedValue =
	[(NSString *)CFURLCreateStringByAddingPercentEscapes(
														 nil,
														 (CFStringRef)path,
														 NULL,
														 NULL,
														 kCFStringEncodingUTF8)
	 autorelease];
	
	NSURL *url = [NSURL URLWithString:escapedValue];
	streamer = [[AudioStreamer alloc] initWithURL:url];
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}

@end
