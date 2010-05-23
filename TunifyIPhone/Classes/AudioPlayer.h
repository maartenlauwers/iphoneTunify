//
//  AudioPlayer.h
//  TunifyIPhone
//
//  Created by Elegia on 27/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioStreamer.h"
#import "M3U8SegmentInfo.h"
#import "M3U8Playlist.h"
#import "Handler.h"
#import <AVFoundation/AVAudioPlayer.h>

@class AudioStreamer;
@class AudioPlayer;
@protocol AudioPlayerDelegate <NSObject>
@optional
- (void)audioPlayerError:(AudioPlayer *)sender;
@end

@interface AudioPlayer : NSObject <HandlerDelegate, AudioStreamerDelegate> {
	id<AudioPlayerDelegate> delegate;
	BOOL *isPlaying;
	AudioStreamer *streamer;
	NSString *baseUrl;
	M3U8Playlist *playlist;
	float lastUsedVolume;
	
	AVAudioPlayer *avAudioPlayer;
}

@property (nonatomic, retain) id<AudioPlayerDelegate> delegate;
@property (nonatomic, retain) AudioStreamer *streamer;
@property (nonatomic, retain) NSString *baseUrl;
@property (nonatomic, retain) M3U8Playlist *playlist;
@property (nonatomic, retain) AVAudioPlayer *avAudioPlayer;

+ (AudioPlayer*)sharedInstance;

// Usability test methods
- (void)playTest:(NSString *)song;
- (void)setVolumeTest:(float)volume;
- (void)decreaseVolume;
- (void)increaseVolume;
- (void)stopTest;


- (void)play:(NSString *)path;
- (void)setVolume:(float)volume;
- (void)stop;
- (void)destroyStreamer;
@end
