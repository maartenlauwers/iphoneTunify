//
//  CustomUIImagePickerController.m
//  TunifyIPhone
//
//  Created by thesis on 20/03/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomUIImagePickerController.h"


@implementation CustomUIImagePickerController

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
	
	/*
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = 1.0f/60.0f;
	NSLog(@"accelerometer configured");
	*/
	/*
	NSLog(@"picker viewDidLoad");
	//UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	//accel.delegate = self;
	//accel.updateInterval = 1.0f/60.0f;
	//NSLog(@"accelerometer configured");
	
	PubCard *card1 = [[PubCard alloc] initWithPub:@"De Werf" pubAddress:@"Tiensestraat 49 3000 Leuven" pubVisitors:45 pubRating:3];
	[card1 setPosition:300 y:100];	
	PubCard *card2 = [[PubCard alloc] initWithPub:@"Passevit" pubAddress:@"Veurnestraat 123 8970 Poperinge" pubVisitors:12 pubRating:4];
	[card2 setPosition:100 y:300];
	
	NSLog(@"picker cards created");
	
	//[self.view insertSubview:card1 atIndex:0];
	NSLog(@"picker inserted subview");
	//[self.view insertSubview:card2 atIndex:1];
	*/
} 

- (void)accelerometer:(UIAccelerometer *)acel didAccelerate:(UIAcceleration *)acceleration {
	
	
	
	if (fabsf(acceleration.x) > 1.5 || fabsf(acceleration.y) > 1.5 || fabsf(acceleration.z) > 1.5)
	{
		NSLog(@"X: %d, Y: %d, Z: %d", acceleration.x, acceleration.y, acceleration.z);
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
