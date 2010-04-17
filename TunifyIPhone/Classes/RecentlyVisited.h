//
//  RecentlyVisited.h
//  TunifyIPhone
//
//  Created by Maarten on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pub.h"

@interface RecentlyVisited : NSObject {
	NSMutableArray *recentPubs;
}

+ (RecentlyVisited *)sharedInstance;
- (void) addPub:(Pub *)pub;
- (NSMutableArray *) getRecentPubs;
@end
