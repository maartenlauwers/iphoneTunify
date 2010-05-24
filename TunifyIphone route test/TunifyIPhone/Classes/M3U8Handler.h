//
//  M3U8Handler.h
//  TunifyIPhone
//
//  Created by Elegia on 27/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M3U8Playlist.h";

@class M3U8Handler;
@protocol M3U8HandlerDelegate <NSObject>
@optional
- (void)playlistAvailable:(M3U8Handler *)sender;
- (void)playlistParseError:(M3U8Handler *)sender;
@end

@interface M3U8Handler : NSObject {
	id<M3U8HandlerDelegate> delegate;
	M3U8Playlist *playlist;
}

@property (assign) id<M3U8HandlerDelegate> delegate;
@property (nonatomic, retain) M3U8Playlist *playlist;

+ (M3U8Handler *)sharedInstance;
- (void)parseUrl:(NSString *)url;

@end
