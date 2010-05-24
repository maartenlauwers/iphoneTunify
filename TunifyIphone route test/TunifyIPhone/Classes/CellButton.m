//
//  PlayPauzeButton.m
//  TunifyIPhone
//
//  Created by thesis on 21/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CellButton.h"


@implementation CellButton
@synthesize row;

- (id)init {
    if (self = [super init]) {
		self.row = -1;
    }
    return self;
}

- (void) dealloc {
	[super dealloc]; // If we do this, the dealloc causes a crash. Still need to figure out why.
}

@end
