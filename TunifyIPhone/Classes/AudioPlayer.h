//
//  AudioPlayer.h
//  TunifyIPhone
//
//  Created by Elegia on 27/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioStreamer.h"
#import "M3U8Handler.h"
#import "M3U8SegmentInfo.h"
#import "M3U8Playlist.h"

@class AudioStreamer;

@interface AudioPlayer : NSObject <M3U8HandlerDelegate, AudioStreamerDelegate> {
	BOOL *isPlaying;
	AudioStreamer *streamer;
	NSString *baseUrl;
	M3U8Playlist *playlist;
	float lastUsedVolume;
}

@property (nonatomic, retain) AudioStreamer *streamer;
@property (nonatomic, retain) NSString *baseUrl;
@property (nonatomic, retain) M3U8Playlist *playlist;

+ (AudioPlayer*)sharedInstance;
- (void)play:(NSString *)path;
- (void)setVolume:(float)volume;
- (void)stop;
- (void)createStreamer:(NSString*)path;
- (void)destroyStreamer;
@end
