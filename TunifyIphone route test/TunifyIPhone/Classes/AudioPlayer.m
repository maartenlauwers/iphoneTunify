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
@synthesize delegate;
@synthesize avAudioPlayer;
@synthesize currentVolume;

int currentSegment;

// Singleton methods

+ (AudioPlayer*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[AudioPlayer alloc] init];
			//lastUsedVolume = 0.5;
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

- (void)isAvailable {
	
}

#pragma mark -
#pragma mark Local playing methods for usability testing

- (void)playTest:(NSString *)song {
	if (! [self.avAudioPlayer isPlaying]) {
		NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:song ofType:@"mp3"];
		NSURL *audioFileURL = [NSURL fileURLWithPath:audioFilePath];
		self.avAudioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:audioFileURL error:nil] autorelease];
		[self.avAudioPlayer prepareToPlay];
		[self.avAudioPlayer setVolume:self.currentVolume];
		[self.avAudioPlayer play];
		NSLog(@"playing with volume: %f", self.avAudioPlayer.volume);
	}
}

- (void)setVolumeTest:(float)volume {
	NSLog(@"Setting volume");
	[self.avAudioPlayer setVolume:volume];
	self.currentVolume = volume;
	NSLog(@"volume set at: %f", self.avAudioPlayer.volume);
}

- (void)decreaseVolume {
	if([self.avAudioPlayer volume] > 0) {
		[self.avAudioPlayer setVolume:([self.avAudioPlayer volume] - 0.1)];
		self.currentVolume -= 0.1;
	}
}

- (void)increaseVolume {
	if([self.avAudioPlayer volume] < 1.0) {
		[self.avAudioPlayer setVolume:([self.avAudioPlayer volume] + 0.1)];
		self.currentVolume += 0.1;
	}
}

- (void)stopTest {
	[self.avAudioPlayer stop];
}

#pragma mark -
#pragma mark Streaming audio methods
- (void)play:(NSString *)path 
{
	NSLog(@"Play");
	// Subtract the "playlist.m3u8" part to get the base url
	NSRange r = [path rangeOfString:@"/playlist.m3u8"];
	self.baseUrl = [path substringToIndex:r.location];
	
	NSLog(@"starting handler");
	Handler *handler = [[Handler alloc] init];
	NSLog(@"Handler started");
	handler.delegate = self;
	[handler parseUrl:path];
	NSLog(@"End Play");
}

- (void)playlistAvailable:(Handler *)sender {

	self.playlist = sender.playlist;
	currentSegment = 0;
	
	if (streamer) {
		[streamer stop];
		streamer = nil;
	}
	streamer = [[AudioStreamer alloc] initWithPlaylist:self.playlist andBaseURL:self.baseUrl];
	streamer.delegate = self;
	[streamer startWithVolume:lastUsedVolume];
	[sender release];
}

- (void)playlistParseError:(Handler *)sender {
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(audioPlayerError:)]) {
		[delegate audioPlayerError:self];
	}  
}

- (void)setVolume:(float)volume {
	[streamer setVolume:volume];
	lastUsedVolume = volume;
	NSLog(@"lastUsedVolume: %f", lastUsedVolume);
}

- (void)stop {
	[streamer stop];
	streamer = nil;
	delegate = nil;
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	[avAudioPlayer release];
	if (streamer)
	{
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}

@end
