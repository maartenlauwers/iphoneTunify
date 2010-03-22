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

- (void) dealloc {
	[indexPath release];
	[self dealloc];
}

@end
