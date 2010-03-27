//
//  TunifyIPhoneAppDelegate.m
//  TunifyIPhone
//
//  Created by thesis on 15/02/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TunifyIPhoneAppDelegate.h"

@implementation TunifyIPhoneAppDelegate

@synthesize window;
@synthesize tabController;
@synthesize audioPlayer;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	self.audioPlayer = [[AudioPlayer alloc] init];
    [window addSubview:tabController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[audioPlayer release];
	[tabController release];
    [window release];
    [super dealloc];
}


@end
