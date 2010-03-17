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
	
	
	NSLog(@"Creating glview");
	glView = [[GLView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
	glView.delegate = self;
	//self.view = glView;
	[self.view addSubview:glView];
	NSLog(@"glView created");
	
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


- (void)drawView:(UIView *)theView
{
	
	NSLog(@"Drawing view");
    static GLfloat rot = 0.0;
    
    // This is the same result as using Vertex3D, just faster to type and
    // can be made const this way
	/*
    static const Vertex3D vertices[]= {
        {0, -0.525731, 0.850651},             // vertices[0]
        {0.850651, 0, 0.525731},              // vertices[1]
        {0.850651, 0, -0.525731},             // vertices[2]
        {-0.850651, 0, -0.525731},            // vertices[3]
        {-0.850651, 0, 0.525731},             // vertices[4]
        {-0.525731, 0.850651, 0},             // vertices[5]
        {0.525731, 0.850651, 0},              // vertices[6]
        {0.525731, -0.850651, 0},             // vertices[7]
        {-0.525731, -0.850651, 0},            // vertices[8]
        {0, -0.525731, -0.850651},            // vertices[9]
        {0, 0.525731, -0.850651},             // vertices[10]
        {0, 0.525731, 0.850651}               // vertices[11]
    };
    
    static const Color3D colors[] = {
		{1.0, 0.0, 0.0, 1.0},
		{1.0, 0.5, 0.0, 1.0},
		{1.0, 1.0, 0.0, 1.0},
		{0.5, 1.0, 0.0, 1.0},
		{0.0, 1.0, 0.0, 1.0},
		{0.0, 1.0, 0.5, 1.0},
		{0.0, 1.0, 1.0, 1.0},
		{0.0, 0.5, 1.0, 1.0},
		{0.0, 0.0, 1.0, 1.0},
		{0.5, 0.0, 1.0, 1.0},
		{1.0, 0.0, 1.0, 1.0},
		{1.0, 0.0, 0.5, 1.0}
    };
    
    static const GLubyte icosahedronFaces[] = {
        1, 2, 6,
        1, 7, 2,
        3, 4, 5,
        4, 3, 8,
        6, 5, 11,
        5, 6, 10,
        9, 10, 2,
        10, 9, 3,
        7, 8, 9,
        8, 7, 0,
        11, 0, 1,
        0, 11, 4,
        6, 2, 10,
        1, 6, 11,
        3, 5, 10,
        5, 4, 11,
        2, 7, 9,
        7, 1, 0,
        3, 9, 8,
        4, 8, 0,
    };
	 */
	
	static const Vertex3D vertices[]= {
		
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
		{-0.15f, 0.0f, 1.5f},				// 11
		{-0.15f, -0.3f, 1.5f},				// 12
		
		// box right side
		{0.15f, 0.0f, -0.2f},				// 13
		{0.15f, -0.3f, -0.2f},				// 14
		{0.15f, 0.0f, 1.5f},				// 15
		{0.15f, -0.3f, 1.5f},				// 16
		
		// box closest side
		{0.15f, 0.0f, 1.5f},				// 17
		{0.15f, -0.3f, 1.5f},				// 18
		{-0.15f, 0.0f, 1.5f},				// 19
		{-0.15f, -0.3f, 1.5f},				// 20
		
		// box top side
		{0.15f, 0.0f, -0.2f},				// 21
		{-0.15f, 0.0f, -0.2f},				// 22
		{0.15f, 0.0f, 1.5f},				// 23
		{-0.15f, 0.0f, 1.5f}				// 24
		
    };
    
    static const Color3D colors[] = {
		// pointer sides
		{1.0, 0.0, 0.0, 1.0},
		{1.0, 0.0, 0.0, 1.0},
		{0.0, 1.0, 0.0, 1.0},
		{0.0, 1.0, 0.0, 1.0},
		{0.0, 0.0, 1.0, 1.0},
		{0.0, 0.0, 1.0, 1.0},
		
		// pointer roof
		{0.5, 0.5, 0.5, 1.0},
		{0.5, 0.5, 0.5, 1.0},
		{0.5, 0.5, 0.5, 1.0},
		
		//box left side
		{0.5, 0.5, 0.5, 1.0},
		{0.5, 0.5, 0.5, 1.0},
		{0.5, 0.5, 0.5, 1.0},
		{0.5, 0.5, 0.5, 1.0},
		
		//box right side
		{0.5, 0.5, 0.1, 1.0},
		{0.5, 0.5, 0.1, 1.0},
		{0.5, 0.5, 0.1, 1.0},
		{0.5, 0.5, 0.1, 1.0},
		
		//box closest side
		{0.5, 0.2, 0.5, 1.0},
		{0.5, 0.2, 0.5, 1.0},
		{0.5, 0.2, 0.5, 1.0},
		{0.5, 0.2, 0.5, 1.0},
		
		//box top side
		{0.8, 0.5, 0.5, 1.0},
		{0.8, 0.5, 0.5, 1.0},
		{0.8, 0.5, 0.5, 1.0},
		{0.8, 0.5, 0.5, 1.0}
		 
    };
    
    static const GLubyte icosahedronFaces[] = {
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
		
		/*
		5, 3, 4,
		6, 4, 2,
		5, 1, 6,
		1, 2, 6,
		 */
    };
    
    glLoadIdentity();
    glTranslatef(0.0f,0.0f,-3.0f);
	glScalef(0.5f, 0.5f, 0.5f);
    glRotatef(45,1.0f,0.0f,0.0f);
	glRotatef(rot, 0.0f, 1.0f, 0.0f);
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
	
    glDrawElements(GL_TRIANGLES, 45, GL_UNSIGNED_BYTE, icosahedronFaces);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
	
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
        rot+=20 * timeSinceLastDraw;                
    }
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
	
	NSLog(@"View drawn");
    
}
-(void)setupView:(GLView*)view
{
	NSLog(@"Setup view");
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
	
	NSLog(@"View setup");
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
	[glView release];
    [super dealloc];
}


@end
