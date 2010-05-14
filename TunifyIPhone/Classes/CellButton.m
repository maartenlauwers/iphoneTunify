//
//  PlayPauzeButton.m
//  TunifyIPhone
//
//  Created by thesis on 21/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CellButton.h"


@implementation CellButton
@synthesize indexPath;

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void) dealloc {
	[indexPath release];
	//[super dealloc]; // If we do this, the dealloc causes a crash. Still need to figure out why.
}

@end
