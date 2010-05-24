//
//  Handler.h
//  TunifyIPhone
//
//  Created by thesis on 21/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M3U8Playlist.h";

@class Handler;
@protocol HandlerDelegate <NSObject>
@optional
- (void)playlistAvailable:(Handler *)sender;
- (void)playlistParseError:(Handler *)sender;
@end

@interface Handler : NSObject {
	id<HandlerDelegate> delegate;
	M3U8Playlist *playlist;
}

@property (assign) id<HandlerDelegate> delegate;
@property (nonatomic, retain) M3U8Playlist *playlist;

- (void)parseUrl:(NSString *)url;

@end
