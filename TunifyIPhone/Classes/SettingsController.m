//
//  SettingsController.m
//  TunifyIPhone
//
//  Created by Elegia on 23/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsController.h"


@implementation SettingsController
@synthesize radiusSlider;
@synthesize volumeSlider;
@synthesize radiusChangedManually;

-(IBAction) volumeChanged {
	float volume = volumeSlider.value;
	
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	[audioPlayer setVolumeTest:volume];
	//[audioPlayer setVolume:volume];
}

-(IBAction) radiusChanged {
	float radius = radiusSlider.value;
	
	TunifyIPhoneAppDelegate *appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate]; 
	appDelegate.radius = radius;
	
	self.radiusChangedManually = TRUE;
}

- (void)viewDidAppear {
    [super viewDidAppear:YES];
	
	if(radiusChangedManually == FALSE) {
		TunifyIPhoneAppDelegate *appDelegate = (TunifyIPhoneAppDelegate*)[[UIApplication sharedApplication] delegate]; 
		self.radiusSlider.value = appDelegate.radius;
	}
	
	AudioPlayer *audioPlayer = [AudioPlayer sharedInstance];
	self.volumeSlider.value = audioPlayer.currentVolume;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if(! self.radiusChangedManually == TRUE) {
		self.radiusChangedManually = FALSE;
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
