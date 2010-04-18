//
//  OverlayView.m
//  TunifyIPhone
//
//  Created by Maarten on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView
@synthesize delegate;

-(void)dealloc {
	delegate = nil;
	[delegate release];
	[super dealloc];
}
@end
