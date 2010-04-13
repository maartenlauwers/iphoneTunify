//
//  RecentlyVisited.m
//  TunifyIPhone
//
//  Created by Maarten on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RecentlyVisited.h"


@implementation RecentlyVisited


static RecentlyVisited *sharedInstance = nil;

// Singleton methods

+ (RecentlyVisited *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[RecentlyVisited alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
			NSLog(@"AllocWithZone");
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
    [recentPubs release];
}

- (id)autorelease {
    return self;
}

- (void) addPub:(NSArray *)pub {
	
	if (recentPubs == nil) {
		recentPubs = [[NSMutableArray alloc] init];
	}
	
	NSLog(@"Adding pub");
	// Remove doubles
	
	for (NSArray *recentPub in recentPubs) {
		if ([pub name] == [recentPub name]) {
			[recentPubs removeObject:recentPub];
			break;
		}
	}
	
	[recentPubs insertObject:pub atIndex:0];
	NSLog(@"Pub count: %d", [recentPubs count]);
	NSLog(@"pub added");
}

- (NSMutableArray *) getRecentPubs {
	NSLog(@"getRecentPubs: %d", [recentPubs count]);
	return recentPubs;
}

- (void) dealloc {
	[recentPubs release];
	[super dealloc];
}


@end
