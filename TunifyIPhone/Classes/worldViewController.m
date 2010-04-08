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

@synthesize strPubName;
@synthesize glView;
@synthesize capturedToggle;
@synthesize strPubAddress;
@synthesize pubLocation;
@synthesize userLocation;
@synthesize distance;
@synthesize lblDistanceToDestination;
@synthesize ct;

GLfloat rot = 0.0;
Vertex3D vertices[]= {

// pointer sides
{0, 0.0f, -1.0f},					// 0
{0, -0.3f, -1.0f},					// 1
{-0.5f, 0.0f, -0.2f},				// 2
{-0.5f, -0.3f, -0.2f},				// 3
{0.5f, 0.0f, -0.2f},				// 4
{0.5f, -0.3f, -0.2f},				// 5

// pointer roof
{0, 0.0f, -1.0f},					// 6
{-0.5f, 0.0f, -0.2f},				// 7
{0.5f, 0.0f, -0.2f},				// 8

// box left side	
{-0.15f, 0.0f, -0.2f},				// 9
{-0.15f, -0.3f, -0.2f},				// 10
{-0.15f, 0.0f, 1.0f},				// 11
{-0.15f, -0.3f, 1.0f},				// 12

// box right side
{0.15f, 0.0f, -0.2f},				// 13
{0.15f, -0.3f, -0.2f},				// 14
{0.15f, 0.0f, 1.0f},				// 15
{0.15f, -0.3f, 1.0f},				// 16

// box closest side
{0.15f, 0.0f, 1.0f},				// 17
{0.15f, -0.3f, 1.0f},				// 18
{-0.15f, 0.0f, 1.0f},				// 19
{-0.15f, -0.3f, 1.0f},				// 20

// box top side
{0.15f, 0.0f, -0.2f},				// 21
{-0.15f, 0.0f, -0.2f},				// 22
{0.15f, 0.0f, 1.0f},				// 23
{-0.15f, 0.0f, 1.0f}				// 24

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
	controller.strPubName = strPubName;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	controller = nil;
}

- (IBAction) capturedToggleChanged:(id)sender {
	
	if(capturedToggle.selectedSegmentIndex == 0) {
		
		[ct stop];
		self.glView.delegate = nil;
		[glView stopAnimation];
		[self.glView removeFromSuperview];
		[self.glView release];
		
		mapViewController *controller = [[mapViewController alloc] initWithNibName:@"mapView" bundle:[NSBundle mainBundle]];
		controller.strPubName = self.strPubName;
		controller.strPubAddress = self.strPubAddress;
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
	
	
	self.navigationItem.title = strPubName;
	
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
	[self initAll];
} 

-(void)initAll {
	self.lblDistanceToDestination.text = @"";
	self.distance = -1;
	self.userLocation = nil;
	self.pubLocation = nil;
	
	// Fetch the user and pub coordinates
	ct = [[CoordinatesTool alloc] init];
	ct.delegate = self;
	[ct fetchUserLocation];
	[ct fetchPubLocation:self.strPubAddress];
	[ct fetchHeading];
	
	// Create the 3D pointer arrow view
	self.glView = [[GLView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
	self.glView.delegate = self;
	self.glView.opaque = NO;
	[self.view addSubview:self.glView];
	self.glView.animationInterval = 1.0 / kRenderingFrequency;
	[self.glView startAnimation];
	
	
}

- (void)userLocationFound:(CoordinatesTool *)sender {
	self.userLocation = sender.userLocation;
	if (sender.userLocationOK == TRUE && sender.pubLocationOK == TRUE) {
		self.distance = [sender fetchDistance];
		[self updateDistance];
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
		[self updateDistance];
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

- (void)updateDistance {
	self.lblDistanceToDestination.text = [NSString stringWithFormat:@"Destination at %.0f meters.", self.distance];
	rot = *[self getArrowHeading];
}

- (GLfloat *)getArrowHeading {
	float x1 = userLocation.coordinate.latitude;					//Our position.
	float y1 = userLocation.coordinate.longitude;
	float x2 = pubLocation.coordinate.latitude;		//The other thing's position.
	float y2 = pubLocation.coordinate.longitude;
	NSLog(@"x1: %f, y1: %f, x2: %f, y2: %f", x1, y1, x2, y2);
	float result;						//The resulting bearing.
	
	//x2 = -3;
	//y2 = 3;
	
	// Base vector
	float bx = 0;
	float by = 1;
	
	// Normalize our pub location vector by subtracting the basevector from it.
	//float normalizedX2 = x2;//-x1;//-bx1;
	//float normalizedY2 = y2;//-by1;
	float normalizedX2 = x2-x1;
	float normalizedY2 = y2-y1;
	
	
	// Imagine we know our compass degrees, assume 0 degrees
	float heading = 360; //TODO: Replace by actual degrees of the direction we're facing * -1

	// Update our base vector by the above degrees
	/*
	float degreesRad = degrees * (M_PI/180);
	float Nbx = (bx * cos(degreesRad)) - (by * sin(degreesRad));
	float Nby = (bx * sin(degreesRad)) + (by * cos(degreesRad));
	NSLog(@"Nbx: %f", Nbx);
	NSLog(@"Nby: %f", Nby);
	*/
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
	 
	NSLog(@"Heading: %.0f", resultDeg);
	
	GLfloat *glHeading = (GLfloat *)malloc(sizeof(GLfloat));
	
	// fill out the coords here
	
	*glHeading = resultDeg;
	return glHeading;
}

- (void)drawView:(UIView *)theView
{
	
    
    
    glLoadIdentity();
    glTranslatef(0.0f,0.0f,-3.0f);
	glScalef(0.5f, 0.5f, 0.5f);
    glRotatef(45,1.0f,0.0f,0.0f);
	glRotatef(0, 0.0f, 1.0f, 0.0f);
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
        rot+=50 * timeSinceLastDraw;                
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
	
	[strPubName release];
	[lblDistanceToDestination release];
	[userLocation release];
	[pubLocation release];
	[ct release];
	[capturedToggle release];
    [super dealloc];
}


@end
