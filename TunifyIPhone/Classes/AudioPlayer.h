//
//  AudioPlayer.h
//  TunifyIPhone
//
//  Created by Elegia on 27/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioStreamer;

@interface AudioPlayer : NSObject {
	BOOL *isPlaying;
	AudioStreamer *streamer;
}

@property (nonatomic, retain) AudioStreamer *streamer;
- (void)play:(NSString *)path;
- (void)stop;
- (void)createStreamer:(NSString*)path;
- (void)destroyStreamer;
@end
