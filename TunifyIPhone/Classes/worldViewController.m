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
@synthesize strPubAddress;
@synthesize pubLocation;
@synthesize userLocation;
@synthesize distance;
@synthesize locationManager;
@synthesize lblDistanceToDestination;

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
	
	[glView stopAnimation];
	
	// Show the tab bar (because the pubs view needs it)
	if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *view = [self.tabBarController.view.subviews objectAtIndex:0];
        UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
		
		[view sizeToFit];
		tabBar.hidden = FALSE;
	}
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) btnMusic_clicked:(id)sender {
	musicViewController *mvc = [[musicViewController alloc] initWithNibName:@"musicView" bundle:[NSBundle mainBundle]];
	mvc.strPubName = strPubName;
	[self.navigationController pushViewController:mvc animated:YES];
	[mvc release];
	mvc = nil;
}

- (IBAction) capturedToggleChanged:(id)sender {
	
	if(capturedToggle.selectedSegmentIndex == 0) {
		mapViewController *mvc = [[mapViewController alloc] initWithNibName:@"mapView" bundle:[NSBundle mainBundle]];
		mvc.strPubName = strPubName;
		[self.navigationController pushViewController:mvc animated:YES];
		[mvc release];
		mvc = nil;
	}
}

// Convert our passed value to Radians
double ToRad( double nVal )
{
	return nVal * (M_PI/180);
}

double CalculateDistance( double nLat1, double nLon1, double nLat2, double nLon2 )
{
    double nRadius = 6371; // Earth's radius in Kilometers
    // Get the difference between our two points
    // then convert the difference into radians
	
    double nDLat = ToRad(nLat2 - nLat1);
    double nDLon = ToRad(nLon2 - nLon1);
	
    // Here is the new line
    nLat1 =  ToRad(nLat1);
    nLat2 =  ToRad(nLat2);
	
    double nA = pow ( sin(nDLat/2), 2 ) + cos(nLat1) * cos(nLat2) * pow ( sin(nDLon/2), 2 );
	
    double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
    double nD = nRadius * nC;
	
    return nD; // Return our calculated distance
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
	
	//[self getCoordinates];
	
	
	CoordinatesTool *ct = [[CoordinatesTool alloc] init];
	ct.delegate = self;
	[ct fetchUserLocation];
	self.pubLocation = [ct fetchPubLocation:self.strPubAddress];
	
	/*
	// Calculate the distance between the two points
	
	NSRange kommaRange = [pubCoordinates rangeOfString:@","];
	CLLocationDegrees pubLatitude = [[pubCoordinates substringWithRange:NSMakeRange(0, kommaRange.location)] doubleValue];
	CLLocationDegrees pubLongitude = [[pubCoordinates substringFromIndex:(kommaRange.location + 1)] doubleValue];
	
	kommaRange = [userCoordinates rangeOfString:@","];
	CLLocationDegrees userLatitude = [[userCoordinates substringWithRange:NSMakeRange(0, kommaRange.location)] doubleValue];
	CLLocationDegrees userLongitude = [[userCoordinates substringFromIndex:(kommaRange.location + 1)] doubleValue];
	
	CLLocation* pubLocation = [[[CLLocation alloc] initWithLatitude:pubLatitude longitude:pubLongitude] autorelease];
	CLLocation* userLocation = [[[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongitude] autorelease];
	
	CLLocationDistance distance = [userLocation getDistanceFrom:pubLocation];
	 */
	self.lblDistanceToDestination.text = [NSString stringWithFormat:@"Destination at %.0f meters.", self.distance];
	
	
	glView = [[GLView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
	glView.delegate = self;
	glView.opaque = NO;
	[self.view addSubview:glView];
	glView.animationInterval = 1.0 / kRenderingFrequency;
	[glView startAnimation];

	
	/*
	glView = [[EAGLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	UILabel* distanceLeft = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 300, 20)];
	distanceLeft.text = @"254 meters to go";
	distanceLeft.textAlignment = UITextAlignmentCenter;
	distanceLeft.font = [UIFont systemFontOfSize:18];
	distanceLeft.adjustsFontSizeToFitWidth = NO;
	distanceLeft.textColor = [UIColor blackColor];
	distanceLeft.backgroundColor = [UIColor clearColor];
	[glView addSubview:distanceLeft];
	[distanceLeft release];
	
	self.view = glView;
	*/
}

- (void)userCoordinatesFound:(CoordinatesTool *)sender {
	self.userLocation = sender.userLocation;
	self.distance = [sender fetchDistance];
}

- (void)userCoordinatesError:(CoordinatesTool *)sender {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"title") 
														message:NSLocalizedString(@"An error occured while fetching your position.",  
																				  @"message") 
													   delegate:self 
											  cancelButtonTitle:NSLocalizedString(@"Ok", @"cancel") 
											  otherButtonTitles:nil]; 
	[alertView show]; 
}

/*
- (void) getCoordinates {
	self.locationManager = [[CLLocationManager alloc] init]; 
	self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; 
	self.locationManager.delegate = self; 
	[self.locationManager startUpdatingLocation]; 
	
	// Store the coordinates of the user
	self.userCoordinates = [NSString stringWithFormat:@"%f,%f", 50.8610959, 2.7315335]; // TODO: Replace by actual user coordinates with 
																						// self.locationManager.location.coordinate.latitude;
																						// self.locationManager.location.coordinate.longitude;
	// Fetch the coordinates of the pub
	self.strPubAddress = @"Ieperstraat 100 8970 Poperinge"; // TODO: Replace by actual pub address
	NSString *pubAddress = self.strPubAddress;
	NSString *pubAddressString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv&sensor=false", [pubAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSString *pubAddressURL = [NSString stringWithContentsOfURL:[NSURL URLWithString:pubAddressString]];
	NSArray *userLocationAddressResults = [pubAddressURL componentsSeparatedByString:@","];
	self.pubCoordinates = @"";
	if([userLocationAddressResults count] >= 4 && [[userLocationAddressResults objectAtIndex:0] isEqualToString:@"200"]) {
		
		for(int i=2; i<[userLocationAddressResults count]; i++) {
			if (i == 3) {
				self.pubCoordinates = [self.pubCoordinates stringByAppendingString:@","];
			}
			self.pubCoordinates = [self.pubCoordinates stringByAppendingString:[userLocationAddressResults objectAtIndex:i]];
		}
	}
	else {
		//Error handling
		NSLog(@"Error while getting target address location");
	}
	
}
 */

- (void)drawView:(UIView *)theView
{
	
    static GLfloat rot = 0.0;
    
    glLoadIdentity();
    glTranslatef(0.0f,0.0f,-3.0f);
	glScalef(0.5f, 0.5f, 0.5f);
    glRotatef(45,1.0f,0.0f,0.0f);
	glRotatef(rot, 0.0f, 1.0f, 0.0f);
    glClearColor(0.0, 0.0, 0.0, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);

    glDrawElements(GL_TRIANGLES, 45, GL_UNSIGNED_BYTE, faces);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
	
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
        rot+=50 * timeSinceLastDraw;                
    }
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
	    
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
}


- (void)dealloc {
	[strPubName release];
	[lblDistanceToDestination release];
	[userLocation release];
	[pubLocation release];
	[capturedToggle release];
	[locationManager release];
	[glView release];
    [super dealloc];
}


@end
