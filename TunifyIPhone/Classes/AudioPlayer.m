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

static AudioPlayer *sharedInstance = nil;

@implementation AudioPlayer

@synthesize streamer;
@synthesize baseUrl;
//@synthesize currentSegment;
@synthesize playlist;

int currentSegment;

// Singleton methods

+ (AudioPlayer*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[AudioPlayer alloc] init];
			lastUsedVolume = 0.5;
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

//
// AudioPlayer methods
//

- (void)play:(NSString *)path 
{
	
	// Subtract the "playlist.m3u8" part to get the base url
	NSRange r = [path rangeOfString:@"/playlist.m3u8"];
	self.baseUrl = [path substringToIndex:r.location];
	
	M3U8Handler *handler = [M3U8Handler sharedInstance];
	handler.delegate = self;
	[handler parseUrl:path];
}

- (void)playlistAvailable:(M3U8Handler *)sender {

	self.playlist = sender.playlist;
	currentSegment = 0;

	M3U8SegmentInfo *segment = [self.playlist getSegment:currentSegment];
	if (streamer) {
		[streamer stop];
		streamer = nil;
	}
	streamer = [[AudioStreamer alloc] initWithPlaylist:self.playlist andBaseURL:self.baseUrl];
	streamer.delegate = self;
	[streamer startWithVolume:lastUsedVolume];
}

- (void)playlistParseError:(M3U8Handler *)sender {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"Could not contact the Tunify server. Audio playback will not work.",  
																				  @"message") 
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
											  otherButtonTitles:nil]; 
	
	[alertView show]; 
}

- (void)setVolume:(float)volume {
	[streamer setVolume:volume];
	lastUsedVolume = volume;
	NSLog(@"lastUsedVolume: %f", lastUsedVolume);
}

- (void)stop {
	[streamer stop];
	streamer = nil;
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
/*
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
	streamer.delegate = self;
}
*/
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
