//
//  M3U8SegmentInfo.h
//  TunifyIPhone
//
//  Created by Elegia on 27/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface M3U8SegmentInfo : NSObject {
	NSInteger *duration;
	NSString *location;
}

@property (assign) NSInteger *duration;
@property (nonatomic, retain) NSString *location;

@end
