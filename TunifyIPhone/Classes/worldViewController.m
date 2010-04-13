//
//  worldViewController.m
//  TunifyIPhone
//
//  Created by thesis on 17/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "worldViewController.h"
#import "mapViewController.h"
#import "musicViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"


@implementation worldViewController

@synthesize pub;
@synthesize pubAddress;
@synthesize glView;
@synthesize capturedToggle;
@synthesize pubLocation;
@synthesize userLocation;
@synthesize distance;
@synthesize lblDistanceToDestination;
@synthesize ct;
@synthesize picker;
@synthesize overlayView;

GLfloat rot = 0.0;
Vertex3D vertices[]= {

// pointer sides
{0, 0.0f, -1.3f},					// 0
{0, -0.3f, -1.3f},					// 1
{-0.8f, 0.0f, -0.2f},				// 2
{-0.8f, -0.3f, -0.2f},				// 3
{0.8f, 0.0f, -0.2f},				// 4
{0.8f, -0.3f, -0.2f},				// 5

// pointer roof
{0, 0.0f, -1.3f},					// 6
{-0.8f, 0.0f, -0.2f},				// 7
{0.8f, 0.0f, -0.2f},				// 8

// box left side	
{-0.25f, 0.0f, -0.2f},				// 9
{-0.25f, -0.3f, -0.2f},				// 10
{-0.25f, 0.0f, 1.2f},				// 11
{-0.25f, -0.3f, 1.2f},				// 12

// box right side
{0.25f, 0.0f, -0.2f},				// 13
{0.25f, -0.3f, -0.2f},				// 14
{0.25f, 0.0f, 1.2f},				// 15
{0.25f, -0.3f, 1.2f},				// 16

// box closest side
{0.25f, 0.0f, 1.2f},				// 17
{0.25f, -0.3f, 1.2f},				// 18
{-0.25f, 0.0f, 1.2f},				// 19
{-0.25f, -0.3f, 1.2f},				// 20

// box top side
{0.25f, 0.0f, -0.2f},				// 21
{-0.25f, 0.0f, -0.2f},				// 22
{0.25f, 0.0f, 1.2f},				// 23
{-0.25f, 0.0f, 1.2f}				// 24

};

GLubyte faces[] = {
// pointer sides
0, 2, 1,
2, 1, 3,
0, 4, 5,
0, 5, 1,
4, 2, 3,
4, 3, 5,

// pointer roof
6, 7, 8,

// box left side
9, 11, 12,
9, 12, 10,

// box right side
13, 15, 14,
15, 16, 14,

// box closest side
17, 19, 20,
17, 18, 20,

// box top side
21, 23, 24,
21, 22, 24,
};

Color3D colors[] = {
// pointer sides
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},

// pointer roof
{1.0, 0.8, 0.2, 1.0},
{1.0, 0.8, 0.2, 1.0},
{1.0, 0.8, 0.2, 1.0},

//box left side
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},

//box right side
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},

//box closest side
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},
{1.0, 0.6, 0.2, 1.0},

//box top side
{1.0, 0.8, 0.2, 1.0},
{1.0, 0.8, 0.2, 1.0},
{1.0, 0.8, 0.2, 1.0},
{1.0, 0.8, 0.2, 1.0}

};	

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

- (void) btnPubs_clicked:(id)sender {
	
	// Show the tab bar (because the pubs view needs it)
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		[view sizeToFit];
		tabBar.hidden = FALSE;
	}
	
	[ct stop];
	self.glView.delegate = nil;

	[glView stopAnimation];
	[self.glView removeFromSuperview];
	[self.glView release];
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) btnMusic_clicked:(id)sender {
	
	[ct stop];
	self.glView.delegate = nil;
	[glView stopAnimation];
	[self.glView removeFromSuperview];
	[self.glView release];
	
	musicViewController *controller = [[musicViewController alloc] initWithNibName:@"musicView" bundle:[NSBundle mainBundle]];
	controller.pub = self.pub;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
}

- (IBAction) capturedToggleChanged:(id)sender {
	
	if(capturedToggle.selectedSegmentIndex == 0) {
		
		//[locationTimer invalidate];
		//[locationTimer release];
		ct.delegate = nil;
		[ct stop];

		self.glView.delegate = nil;
		[glView stopAnimation];
		[self.glView removeFromSuperview];
		[self.glView release];
		
		//[self.overlayView release];
		//[self.picker release];
		
		[self dismissModalViewControllerAnimated:YES];
		mapViewController *controller = [[mapViewController alloc] initWithNibName:@"mapView" bundle:[NSBundle mainBundle]];
		controller.pub = self.pub;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
		controller = nil;
		
	}
} 

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Hide the tab bar
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		view.frame = CGRectMake(0, 0, 320, 480 );     
		tabBar.hidden = TRUE;
        
		// Note: These views must not be released because they are still required.
    }

	
	self.navigationItem.title = [self.pub name];
	
	// Create the left bar button item
	UIBarButtonItem *pubsBarButtonItem = [[UIBarButtonItem alloc] init];
	pubsBarButtonItem.title = @"Pubs";
	pubsBarButtonItem.target = self;
	pubsBarButtonItem.action = @selector(btnPubs_clicked:);
	self.navigationItem.leftBarButtonItem = pubsBarButtonItem;
	[pubsBarButtonItem release];
	
	// Create the right bar button item
	UIBarButtonItem *musicBarButtonItem = [[UIBarButtonItem alloc] init];
	musicBarButtonItem.title = @"Music";
	musicBarButtonItem.target = self;
	musicBarButtonItem.action = @selector(btnMusic_clicked:);
	self.navigationItem.rightBarButtonItem = musicBarButtonItem;
	[musicBarButtonItem release];
	
}

-(void) viewDidAppear:(BOOL)animated { 
	[super viewDidAppear:animated]; 
	
	self.lblDistanceToDestination.text = @"";
	
	self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	self.overlayView.opaque = YES;
	
	[self.overlayView insertSubview:self.lblDistanceToDestination atIndex:1];
	[self.overlayView insertSubview:self.capturedToggle atIndex:2];
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		
		self.picker = [[CustomUIImagePickerController alloc] init];
		self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
		self.picker.showsCameraControls = NO;
		self.picker.cameraOverlayView = self.overlayView;
		CGAffineTransform cameraTransform = CGAffineTransformMakeScale(1.0, 1.132);
		self.picker.cameraViewTransform = cameraTransform;
		self.picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
		
		[self presentModalViewController:self.picker animated:YES];
		
	} else {
		self.picker = nil;
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Camera Found"
															message:@"You need a camera to use this application."
														   delegate:self
												  cancelButtonTitle:@"Cancel"
												  otherButtonTitles:@"Ok", nil];
		
		[alertView show];
		[alertView release];
	}
	NSLog(@"picker initialized");
	
	[self initAll];
} 

-(void)initAll {
	
	self.lblDistanceToDestination.text = @"";
	self.distance = -1;
	self.userLocation = nil;
	self.pubLocation = nil;
	
	// Fetch the pub's address
	self.pubAddress = [NSString stringWithFormat:@"%@ %@, %@ %@", [pub street], [pub number], [pub zipcode], [pub city]];
	
	// Fetch the user and pub coordinates
	ct = [[CoordinatesTool alloc] init];
	ct.delegate = self;
	[ct fetchUserLocation];
	[ct fetchPubLocation:self.pubAddress];
	[ct fetchHeading];
	
	
	// Create the 3D pointer arrow view
	self.glView = [[GLView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
	self.glView.delegate = self;
	self.glView.opaque = NO;
	[self.overlayView insertSubview:self.glView atIndex:0];
	//[self.view insertSubview:self.glView atIndex:0];
	self.glView.animationInterval = 1.0 / kRenderingFrequency;
	[self.glView startAnimation];
	
	
	//locationTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateDistance) userInfo:nil repeats: YES];
}

- (void)userLocationFound:(CoordinatesTool *)sender {
	self.userLocation = sender.userLocation;
	if (sender.userLocationOK == TRUE && sender.pubLocationOK == TRUE) {
		self.distance = [sender fetchDistance];
		//[self updateDistance];
	}
}

- (void)userLocationError:(CoordinatesTool *)sender {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"An error occured while fetching your position.",  
																				  @"message") 
														delegate:self 
														cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
														otherButtonTitles:nil]; 
	[alertView show]; 
}

- (void)pubLocationFound:(CoordinatesTool *)sender {
	self.pubLocation = sender.pubLocation;
	if (sender.userLocationOK == TRUE && sender.pubLocationOK == TRUE) {
		self.distance = [sender fetchDistance];
		//[self updateDistance];
	}
}

- (void)pubLocationError:(CoordinatesTool *)sender {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"An error occured while the pub's position.",  
																				  @"message") 
														delegate:self 
														cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
														otherButtonTitles:nil]; 
	[alertView show]; 
}

- (void)headingUpdated:(CoordinatesTool *)sender {
	// Update our arrow
	rot = *[self getArrowHeading];		
}

- (void)updateDistance {
	self.lblDistanceToDestination.text = [NSString stringWithFormat:@"Destination at %.0f meters.", self.distance];
	[ct fetchUserLocation];
}

- (GLfloat *)getArrowHeading {
	float x1 = userLocation.coordinate.latitude;					//Our position.
	float y1 = userLocation.coordinate.longitude;
	float x2 = pubLocation.coordinate.latitude;		//The other thing's position.
	float y2 = pubLocation.coordinate.longitude;
	//NSLog(@"x1: %f, y1: %f, x2: %f, y2: %f", x1, y1, x2, y2);
	float result;						//The resulting bearing.
	
	// Base vector
	float bx = 0;
	float by = 1;
	
	// Normalize our pub location vector by subtracting the basevector from it.
	//float normalizedX2 = x2;//-x1;//-bx1;
	//float normalizedY2 = y2;//-by1;
	float normalizedX2 = x2-x1;
	float normalizedY2 = y2-y1;
	
	
	// Imagine we know our compass degrees, assume 0 degrees
	float heading = [ct getHeading];// 360; //TODO: Replace by actual degrees of the direction we're facing * -1
	//NSLog(@"Received heading: %f", heading);
	
	// Calculate the angle between the direction we're facing and the pub location
	float uv = (normalizedX2*bx) + (normalizedY2*by);
	float normU = sqrt(normalizedX2*normalizedX2 + normalizedY2*normalizedY2);
	float normV = sqrt(bx*bx + by*by);
	float resultRad = acos(uv/(normU * normV));
	float resultDeg = resultRad * (180/M_PI);
	
	// We will always get a value smaller than 180 degrees, so we need to fix this in case the pub's longitude coordinate is in the western
	// hemisphere (meaning that the angle according to our base vector should be > 180 degrees)
	if (normalizedY2 <= 0) {
		resultDeg = (180 - resultDeg) + 180;
	} 
	
	if (heading >= resultDeg) {
		resultDeg = (heading - resultDeg) * -1;
	} else {
		resultDeg = resultDeg - heading;
	}
	 
	//NSLog(@"Resulting heading: %.0f", resultDeg);
	
	GLfloat *glHeading = (GLfloat *)malloc(sizeof(GLfloat));
	*glHeading = resultDeg;
	return glHeading;
}

- (void)drawView:(UIView *)theView
{
    glLoadIdentity();
    glTranslatef(0.0f,0.0f,-3.0f);
	glScalef(0.5f, 0.5f, 0.5f);
	
	// Make the arrow face upwards
    glRotatef(90,1.0f,0.0f,0.0f);
	
	// Rotate the arrow around the Y axis to make it point to our pub
	glRotatef(-rot, 0.0f, 1.0f, 0.0f);
	
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);

    glDrawElements(GL_TRIANGLES, 45, GL_UNSIGNED_BYTE, faces);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
	
	/*
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
    }
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
	*/
}
-(void)setupView:(GLView*)view
{
	
	const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0; 
	GLfloat size; 
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION); 
	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);  
	glMatrixMode(GL_MODELVIEW);
	
	glLoadIdentity(); 
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	
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
	
	ct.delegate = nil;
	self.glView.delegate = nil;
	[self.glView stopAnimation];
	[self.glView removeFromSuperview];
	[self.glView release];
}


- (void)dealloc {
	[picker release];
	[overlayView release];
	[pub release];
	[lblDistanceToDestination release];
	[userLocation release];
	[pubLocation release];
	[pubAddress release];
	[ct release];
	[capturedToggle release];
    [super dealloc];
}


@end
