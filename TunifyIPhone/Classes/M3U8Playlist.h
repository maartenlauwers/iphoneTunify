//
//  M3U8Playlist.h
//  TunifyIPhone
//
//  Created by Elegia on 27/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M3U8SegmentInfo.h"

@interface M3U8Playlist : NSObject {
	NSMutableArray *segments;
	NSInteger length;
}

@property (nonatomic, retain) NSMutableArray *segments;
@property (assign) NSInteger length;

- (id)initWithSegments:(NSMutableArray *)segmentList;
- (M3U8SegmentInfo *)getSegment:(NSInteger)index;

@end
